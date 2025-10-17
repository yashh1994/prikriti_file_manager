declare module 'xlsx' {
  export interface WorkBook {
    SheetNames: string[];
    Sheets: { [key: string]: WorkSheet };
  }

  export interface WorkSheet {
    [key: string]: any;
  }

  export const utils: {
    sheet_to_json: (worksheet: WorkSheet, opts?: any) => any[];
  };

  export function read(data: any, opts?: any): WorkBook;
}