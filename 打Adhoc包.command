#!/bin/bash
#
# 通用 Ad Hoc 打包脚本（上传蒲公英用）
#
# 用法（三选一）：
#   1) 只改下面 MODULE_NAME 一行，然后双击运行
#   2) 终端传模块名：  ./打Adhoc包.command MKBeaconXPlus
#   3) 终端传完整路径：./打Adhoc包.command /Users/aa/Desktop/MKBXPApp/Modules/MKBeaconXDButton
#
# 产物：直接输出到该模块的根目录，文件名为 <工程名>_<版本>_adhoc_<build>.ipa
#       打包完成后自动在 Finder 中选中该文件
#

set -o pipefail

# ================= 每次只改这一行 =================
MODULE_NAME="MKBeaconXDButton"
# =================================================

MODULES_ROOT="/Users/aa/Desktop/MKBXPApp/Modules"   # 全部模块所在的父目录
TEAM_ID=""                                          # 留空则自动从工程里读取

die() {
    echo ""
    echo "❌ $1"
    echo ""
    echo "按回车键关闭窗口..."
    read -r
    exit 1
}

# ---------- 解析模块路径 ----------
INPUT="$1"
if [ -z "$INPUT" ]; then
    INPUT="$MODULE_NAME"
fi

case "$INPUT" in
    /*) MODULE_DIR="$INPUT" ;;
    *)  MODULE_DIR="$MODULES_ROOT/$INPUT" ;;
esac
MODULE_DIR="${MODULE_DIR%/}"

echo "=============================================="
echo " 通用 Ad Hoc 打包脚本"
echo " 模块目录 : $MODULE_DIR"
echo "=============================================="
echo ""

[ -d "$MODULE_DIR" ] || die "模块目录不存在: $MODULE_DIR"

PROJECT=$(/bin/ls -d "$MODULE_DIR"/Example/*.xcodeproj 2>/dev/null | /usr/bin/head -1)
[ -n "$PROJECT" ] || die "在 $MODULE_DIR/Example 下没找到 .xcodeproj"

PROJECT_NAME=$(/usr/bin/basename "$PROJECT" .xcodeproj)

# ---------- Scheme：优先找 -Example ----------
SCHEME=$(/usr/bin/xcodebuild -list -project "$PROJECT" 2>/dev/null \
    | /usr/bin/sed -n '/Schemes:/,$p' \
    | /usr/bin/grep -E "Example" | /usr/bin/head -1 | /usr/bin/xargs)
if [ -z "$SCHEME" ]; then
    SCHEME=$(/usr/bin/xcodebuild -list -project "$PROJECT" 2>/dev/null \
        | /usr/bin/sed -n '/Schemes:/,$p' \
        | /usr/bin/grep -v "Schemes:" | /usr/bin/head -1 | /usr/bin/xargs)
fi
[ -n "$SCHEME" ] || die "找不到可用的 Scheme，请手动打开工程检查"

# ---------- adhoc 配置是否存在 ----------
CONFIG="adhoc"
if ! /usr/bin/grep -q "name = adhoc;" "$PROJECT/project.pbxproj" 2>/dev/null; then
    CONFIG="Release"
fi

# ---------- Team ID ----------
if [ -z "$TEAM_ID" ]; then
    TEAM_ID=$(/usr/bin/grep -oE "DEVELOPMENT_TEAM = [A-Za-z0-9]+;" "$PROJECT/project.pbxproj" 2>/dev/null \
        | /usr/bin/head -1 | /usr/bin/sed -E 's/.*= ([A-Za-z0-9]+);/\1/')
fi
[ -n "$TEAM_ID" ] || die "工程里没有 DEVELOPMENT_TEAM，请在脚本里手动填 TEAM_ID"

OUT_DIR="$MODULE_DIR"
WORK="$HOME/Library/Caches/AdhocExport/${PROJECT_NAME}"
ARCHIVE="$WORK/${PROJECT_NAME}.xcarchive"
DD="$WORK/DerivedData"
EXPORT_DIR="$WORK/export"

echo "工程     : $(/usr/bin/basename "$PROJECT")"
echo "Scheme   : $SCHEME"
echo "配置     : $CONFIG"
echo "Team ID  : $TEAM_ID"
echo "输出目录 : $OUT_DIR"
echo ""

/bin/rm -rf "$ARCHIVE" "$EXPORT_DIR"
/bin/mkdir -p "$WORK" "$OUT_DIR"

# ---------- 1. Archive ----------
echo "▶ Archive 中（首次较慢，之后有 DerivedData 缓存会快很多）..."
/usr/bin/xcodebuild archive \
    -project "$PROJECT" \
    -scheme "$SCHEME" \
    -configuration "$CONFIG" \
    -destination 'generic/platform=iOS' \
    -archivePath "$ARCHIVE" \
    -derivedDataPath "$DD" \
    -allowProvisioningUpdates \
    DEVELOPMENT_TEAM="$TEAM_ID" \
    2>&1 | /usr/bin/grep -E "error:|ARCHIVE (SUCCEEDED|FAILED)"

[ -d "$ARCHIVE" ] || die "Archive 失败，请检查上面的 error 信息"

# ---------- 2. 导出 Ad Hoc IPA ----------
OPT_PLIST="$WORK/exportOptions.plist"
/bin/cat > "$OPT_PLIST" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>method</key>
	<string>ad-hoc</string>
	<key>teamID</key>
	<string>${TEAM_ID}</string>
	<key>signingStyle</key>
	<string>automatic</string>
	<key>compileBitcode</key>
	<false/>
	<key>thinning</key>
	<string>&lt;none&gt;</string>
	<key>stripSwiftSymbols</key>
	<true/>
</dict>
</plist>
PLIST

echo ""
echo "▶ 导出 IPA..."
/usr/bin/xcodebuild -exportArchive \
    -archivePath "$ARCHIVE" \
    -exportPath "$EXPORT_DIR" \
    -exportOptionsPlist "$OPT_PLIST" \
    -allowProvisioningUpdates \
    2>&1 | /usr/bin/grep -E "error:|EXPORT (SUCCEEDED|FAILED)"

RAW_IPA=$(/bin/ls "$EXPORT_DIR"/*.ipa 2>/dev/null | /usr/bin/head -1)
[ -n "$RAW_IPA" ] || die "导出 IPA 失败，请检查上面的 error 信息"

# ---------- 3. 重命名并放到模块根目录 ----------
APP_PLIST=$(/bin/ls -d "$ARCHIVE"/Products/Applications/*.app 2>/dev/null | /usr/bin/head -1)/Info.plist
VERSION=$(/usr/libexec/PlistBuddy -c "Print :CFBundleShortVersionString" "$APP_PLIST" 2>/dev/null)
BUILD=$(/usr/libexec/PlistBuddy -c "Print :CFBundleVersion" "$APP_PLIST" 2>/dev/null)
[ -n "$VERSION" ] || VERSION="unknown"
[ -n "$BUILD" ] || BUILD="unknown"

FINAL_IPA="$OUT_DIR/${PROJECT_NAME}_${VERSION}_adhoc_${BUILD}.ipa"
/bin/rm -f "$FINAL_IPA"
/bin/cp "$RAW_IPA" "$FINAL_IPA"

echo ""
echo "✅ 打包完成"
echo "   版本: $VERSION ($BUILD)"
echo "   路径: $FINAL_IPA"
echo "   大小: $(/bin/ls -lh "$FINAL_IPA" | /usr/bin/awk '{print $5}')"
echo ""
echo "已打开 Finder 并选中该文件，直接拖到蒲公英即可。"

/usr/bin/open -R "$FINAL_IPA"
