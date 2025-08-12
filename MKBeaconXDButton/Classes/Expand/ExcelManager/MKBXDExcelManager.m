//
//  MKBXDExcelManager.m
//  MKBeaconXDButton_Example
//
//  Created by aa on 2025/2/26.
//  Copyright © 2025 lovexiaoxia. All rights reserved.
//

#import "MKBXDExcelManager.h"

#import <xlsxwriter/xlsxwriter.h>

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

#import "MKExcelWookbook.h"

@implementation MKBXDExcelManager

+ (void)exportExcelWithEventDataList:(NSArray <NSDictionary *>*)list
                            sucBlock:(void(^)(void))sucBlock
                         failedBlock:(void(^)(NSError *error))failedBlock {
    if (!ValidArray(list)) {
        if (sucBlock) {
            moko_dispatch_main_safe(^{
                sucBlock();
            });
        }
        return;
    }
    //设置excel文件名和路径
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [documentPath stringByAppendingPathComponent:@"eventData.xlsx"];
    //创建新xlsx文件
    lxw_workbook *workbook = workbook_new([path UTF8String]);
    //创建sheet
    lxw_sheet *worksheet = workbook_add_worksheet(workbook, NULL);
    
    //设置列宽
    /*
     五个参数分别是:
     worksheet          Pointer to a lxw_worksheet instance to be uodated.
     first_col          The zero indexed first column.
     last_col           The zero indexed last column.
     width              The width of the column(s).
     format             A pointer to a format instance or NULL.
     */
    worksheet_set_column(worksheet, 0, 2, 50, NULL);
    
    //添加格式
    lxw_format *format = workbook_add_format(workbook);
    //设置格式
    format_set_bold(format);
    //水平居中
//    format_set_align(format, LXW_ALIGN_CENTER);
    //垂直居中
    format_set_align(format, LXW_ALIGN_VERTICAL_CENTER);
    
    //写入数据
    /*
     第一个参数是工作表
     第二个参数是行数(索引从0开始)
     第三个参数是列数(索引从0开始)
     第四个参数是写入的内容
     第五个参数是单元格样式，可为NULL.
     */
    worksheet_write_string(worksheet, 0, 0, "timestamp", NULL);
    worksheet_write_string(worksheet, 0, 1, "eventType", NULL);
    
    for (NSInteger i = 0; i < list.count; i ++) {
        NSDictionary *dic = list[i];
        worksheet_write_string(worksheet, i + 1, 0, [SafeStr(dic[@"timestamp"]) UTF8String], NULL);
        worksheet_write_string(worksheet, i + 1, 1, [SafeStr(dic[@"eventType"]) UTF8String], NULL);
    }
    
    //关闭，保存文件
    lxw_error errorCode = workbook_close(workbook);
    if (errorCode != LXW_NO_ERROR) {
        //写失败
        NSError *error = [[NSError alloc] initWithDomain:@"excelOperation"
                                                    code:-999
                                                userInfo:@{@"errorInfo":@"Export Failed"}];
        if (failedBlock) {
            moko_dispatch_main_safe(^{
                failedBlock(error);
            });
        }
        return;
    }
    //写成功
    if (sucBlock) {
        moko_dispatch_main_safe(^{
            sucBlock();
        });
    }
}

+ (void)deleteDataListWithSucBlock:(void(^)(void))sucBlock
                       failedBlock:(void(^)(NSError *error))failedBlock {
    //设置excel文件名和路径
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [documentPath stringByAppendingPathComponent:@"eventData.xlsx"];
    NSError *error = nil;
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        if (sucBlock) {
            moko_dispatch_main_safe(^{
                sucBlock();
            });
        }
        return;
    }
    BOOL success = [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
    if (!success) {
        //删除失败
        NSError *error = [[NSError alloc] initWithDomain:@"excelOperation"
                                                    code:-999
                                                userInfo:@{@"errorInfo":@"Delete Failed"}];
        if (failedBlock) {
            moko_dispatch_main_safe(^{
                failedBlock(error);
            });
        }
        return;
    }
    if (sucBlock) {
        moko_dispatch_main_safe(^{
            sucBlock();
        });
    }
}

@end
