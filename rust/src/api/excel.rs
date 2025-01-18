use calamine::{open_workbook_auto, Reader};

use crate::frb_generated::StreamSink;

#[flutter_rust_bridge::frb(sync)]
pub fn readFile(
    path: String,
    sheet: Option<String>,
    sink: StreamSink<Vec<String>>,
) -> Result<(), String> {
    // Attempt to open the workbook
    let mut workbook =
        open_workbook_auto(&path).map_err(|e| format!("Failed to open file {} : {}", &path, e))?;

    // Determine the sheet name
    let sheet_name = sheet.unwrap_or_else(|| {
        workbook
            .sheet_names()
            .get(0)
            .cloned()
            .unwrap_or_else(|| "Sheet1".to_string())
    });

    // Attempt to get the worksheet range
    let range = workbook
        .worksheet_range(&sheet_name)
        .expect("Failed to read sheet");
    // .ok_or_else(|| format!("Sheet '{}' not found", sheet_name))
    // .and_then(|res| res.map_err(|e| format!("Failed to read sheet: {}", e)))?;

    // Iterate over rows and send data to the sink
    for row in range.rows() {
        let row_data = row
            .iter()
            .map(|cell| cell.to_string())
            .collect::<Vec<String>>();

        sink.add(row_data);
    }

    Ok(()) // Return Ok if everything succeeded
}

#[flutter_rust_bridge::frb(sync)]
pub fn getSheets(path: String) -> Result<Vec<String>, String> {
    let workbook =
        open_workbook_auto(&path).map_err(|e| format!("Failed to open file {} : {}", &path, e))?;
    Ok(workbook.sheet_names().to_vec())
}

#[flutter_rust_bridge::frb(init)]
pub fn init_app() {
    // Default utilities - feel free to customize
    flutter_rust_bridge::setup_default_user_utils();
}
