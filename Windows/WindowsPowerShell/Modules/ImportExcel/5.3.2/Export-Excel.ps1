﻿function Export-Excel {
    <#
        .SYNOPSIS
            Export data to an Excel worksheet.
        .DESCRIPTION
            Export data to an Excel file and where possible try to convert numbers so Excel recognizes them as numbers instead of text. After all. Excel is a spreadsheet program used for number manipulation and calculations. In case the number conversion is not desired, use the parameter '-NoNumberConversion *'.
        .PARAMETER Path
            Path to a new or existing .XLSX file.
        .PARAMETER  ExcelPackage
            An object representing an Excel Package - usually this is returned by specifying -Passthru allowing multiple commands to work on the same Workbook without saving and reloading each time.
        .PARAMETER WorksheetName
            The name of a sheet within the workbook - "Sheet1" by default.
        .PARAMETER ClearSheet
            If specified Export-Excel will remove any existing worksheet with the selected name. The Default behaviour is to overwrite cells in this sheet as needed (but leaving non-overwritten ones in place).
        .PARAMETER Append
            If specified data will be added to the end of an existing sheet, using the same column headings.
        .PARAMETER TargetData
            Data to insert onto the worksheet - this is often provided from the pipeline.
        .PARAMETER DisplayPropertySet
            Many (but not all) objects have a hidden property named psStandardmembers with a child property DefaultDisplayPropertySet ; this parameter reduces the properties exported to those in this set.
        .PARAMETER NoAliasOrScriptPropeties
            Some objects duplicate existing properties by adding aliases, or have Script properties which take a long time to return a value and slow the export down, if specified this removes these properties
        .PARAMETER ExcludeProperty
            Specifies properties which may exist in the target data but should not be placed on the worksheet.
        .PARAMETER Calculate
            If specified a recalculation of the worksheet will be requested before saving.
        .PARAMETER Title
            Text of a title to be placed in the top left cell.
        .PARAMETER TitleBold
            Sets the title in boldface type.
        .PARAMETER TitleSize
            Sets the point size for the title.
        .PARAMETER TitleBackgroundColor
            Sets the cell background color for the title cell.
        .PARAMETER TitleFillPattern
            Sets the fill pattern for the title cell.
        .PARAMETER Password
            Sets password protection on the workbook.
        .PARAMETER IncludePivotTable
            Adds a Pivot table using the data in the worksheet.
        .PARAMETER PivotTableName
            If a Pivot table is created from command line parameters, specificies the name of the new sheet holding the pivot. If Omitted this will be "WorksheetName-PivotTable"
        .PARAMETER PivotRows
            Name(s) columns from the spreadhseet which will provide the Row name(s) in a pivot table created from command line parameters.
        .PARAMETER PivotColumns
            Name(s) columns from the spreadhseet which will provide the Column name(s) in a pivot table created from command line parameters.
        .PARAMETER PivotFilter
            Name(s) columns from the spreadhseet which will provide the Filter name(s) in a pivot table created from command line parameters.
        .PARAMETER PivotData
            In a pivot table created from command line parameters, the fields to use in the table body are given as a Hash table in the form ColumnName = Average|Count|CountNums|Max|Min|Product|None|StdDev|StdDevP|Sum|Var|VarP .
        .PARAMETER PivotDataToColumn
            If there are multiple datasets in a PivotTable, by default they are shown seperatate rows under the given row heading; this switch makes them seperate columns.
        .PARAMETER NoTotalsInPivot
            In a pivot table created from command line parameters, prevents the addition of totals to rows and columns.
        .PARAMETER PivotTableDefinition
            Instead of describing a single pivot table with mutliple commandline paramters; you can use a HashTable in the form PivotTableName = Definition;
            Definition is itself a hashtable with Sheet PivotTows, PivotColumns, PivotData, IncludePivotChart and ChartType values.
        .PARAMETER IncludePivotChart
            Include a chart with the Pivot table - implies -IncludePivotTable.
        .PARAMETER ChartType
            The type for Pivot chart (one of Excel's defined chart types)
        .PARAMETER NoLegend
            Exclude the legend from the pivot chart.
        .PARAMETER ShowCategory
            Add category labels to the pivot chart.
        .PARAMETER ShowPercent
            Add Percentage labels to the pivot chart.
        .PARAMETER ConditionalFormat
            One or more conditional formatting rules defined with New-ConditionalFormattingIconSet.
        .PARAMETER ConditionalText
            Applies a Conditional formatting rule defined with New-ConditionalText. When specific conditions are met the format is applied.
        .PARAMETER NoNumberConversion
            By default we convert all values to numbers if possible, but this isn't always desirable. NoNumberConversion allows you to add exceptions for the conversion. Wildcards (like '*') are allowed.
        .PARAMETER BoldTopRow
            Makes the top Row boldface.
        .PARAMETER NoHeader
            Does not put field names at the top of columns.
        .PARAMETER RangeName
            Makes the data in the worksheet a named range.
        .PARAMETER TableName
            Makes the data in the worksheet a table with a name applies a style to it. Name must not contain spaces.
        .PARAMETER TableStyle
            Selects the style for the named table - defaults to 'Medium6'.
        .PARAMETER BarChart
            Creates a "quick" bar chart using the first text column as labels and the first numeric column as values
        .PARAMETER ColumnChart
            Creates a "quick" column chart using the first text column as labels and the first numeric column as values
        .PARAMETER LineChart
            Creates a "quick" line chart using the first text column as labels and the first numeric column as values
        .PARAMETER PieChart
            Creates a "quick" pie chart using the first text column as labels and the first numeric column as values
        .PARAMETER ExcelChartDefinition
            A hash table containing ChartType, Title, NoLegend, ShowCategory, ShowPercent, Yrange, Xrange and SeriesHeader for one or more [non-pivot] charts.
        .PARAMETER HideSheet
            Name(s) of Sheet(s) to hide in the workbook, supports wildcards. If all sheets would be hidden, the sheet being worked on will be revealed .
        .PARAMETER UnHideSheet
            Name(s) of Sheet(s) to Reveal in the workbook, supports wildcards.
        .PARAMETER MoveToStart
            If specified, the worksheet will be moved to the start of the workbook.
            MoveToStart takes precedence over MoveToEnd, Movebefore and MoveAfter if more than one is specified.
        .PARAMETER MoveToEnd
            If specified, the worksheet will be moved to the end of the workbook.
            (This is the default position for newly created sheets, but this can be used to move existing sheets.)
        .PARAMETER MoveBefore
            If specified, the worksheet will be moved before the nominated one (which can be a postion starting from 1, or a name).
            MoveBefore takes precedence over MoveAfter if both are specified.
        .PARAMETER MoveAfter
            If specified, the worksheet will be moved after the nominated one (which can be a postion starting from 1, or a name or *).
            If * is used, the worksheet names will be examined starting with the first one, and the sheet placed after the last sheet which comes before it alphabetically.
        .PARAMETER KillExcel
            Closes Excel - prevents errors writing to the file because Excel has it open.
        .PARAMETER AutoNameRange
            Makes each column a named range.
        .PARAMETER StartRow
            Row to start adding data. 1 by default. Row 1 will contain the title if any. Then headers will appear (Unless -No header is specified) then the data appears.
        .PARAMETER StartColumn
            Column to start adding data - 1 by default.
        .PARAMETER FreezeTopRow
            Freezes headers etc. in the top row.
        .PARAMETER FreezeFirstColumn
            Freezes titles etc. in the left column.
        .PARAMETER FreezeTopRowFirstColumn
             Freezes top row and left column (equivalent to Freeze pane 2,2 ).
        .PARAMETER FreezePane
             Freezes panes at specified coordinates (in the form  RowNumber , ColumnNumber).
        .PARAMETER AutoFilter
            Enables the 'Filter' in Excel on the complete header row. So users can easily sort, filter and/or search the data in the selected column from within Excel.
        .PARAMETER AutoSize
            Sizes the width of the Excel column to the maximum width needed to display all the containing data in that cell.
        .PARAMETER Activate
            If there is already content in the workbook, a new sheet will not be active UNLESS Activate is specified; if a Pivot table is included it will be the active sheet
        .PARAMETER Now
            The 'Now' switch is a shortcut that creates automatically a temporary file, enables 'AutoSize', 'AutoFiler' and 'Show', and opens the file immediately.
        .PARAMETER NumberFormat
            Formats all values that can be converted to a number to the format specified.

            Examples:
            # integer (not really needed unless you need to round numbers, Excel will use default cell properties).
            '0'

            # integer without displaying the number 0 in the cell.
            '#'

            # number with 1 decimal place.
            '0.0'

            # number with 2 decimal places.
            '0.00'

            # number with 2 decimal places and thousand separator.
            '#,##0.00'

            # number with 2 decimal places and thousand separator and money symbol.
            '€#,##0.00'

            # percentage (1 = 100%, 0.01 = 1%)
            '0%'

            # Blue color for positive numbers and a red color for negative numbers. All numbers will be proceeded by a dollar sign '$'.
            '[Blue]$#,##0.00;[Red]-$#,##0.00'

        .PARAMETER ReZip
            If specified, Export-Excel will expand the contents of the .XLSX file (which is multiple files in a zip archive) and rebuilt it.
        .PARAMETER NoClobber
            Not used. Left in to avoid problems with older scripts, it may be removed in future versions.
        .PARAMETER CellStyleSB
            A script block which is run at the end of the export to apply styles to cells (although it can be used for other purposes).
            The script block is given three paramaters; an object containing the current worksheet, the Total number of Rows and the number of the last column.
        .PARAMETER Show
            Opens the Excel file immediately after creation. Convenient for viewing the results instantly without having to search for the file first.
        .PARAMETER ReturnRange
            If specified, Export-Excel returns the range of added cells in the format "A1:Z100"
        .PARAMETER PassThru
            If specified, Export-Excel returns an object representing the Excel package without saving the package first. To save it you need to call the save or Saveas method or send it back to Export-Excel.

        .EXAMPLE
            Get-Process | Export-Excel .\Test.xlsx -show
            Export all the processes to the Excel file 'Test.xlsx' and open the file immediately.

        .EXAMPLE
        >
        PS> $ExcelParams = @{
                Path    = $env:TEMP + '\Excel.xlsx'
                Show    = $true
                Verbose = $true
            }
            Remove-Item -Path $ExcelParams.Path -Force -EA Ignore
            Write-Output -1 668 34 777 860 -0.5 119 -0.1 234 788 |
                Export-Excel @ExcelParams -NumberFormat '[Blue]$#,##0.00;[Red]-$#,##0.00'

            Exports all data to the Excel file 'Excel.xslx' and colors the negative values in 'Red' and the positive values in 'Blue'. It will also add a dollar sign '$' in front of the rounded numbers to two decimal characters behind the comma.

        .EXAMPLE
        >
        PS> $ExcelParams = @{
                Path    = $env:TEMP + '\Excel.xlsx'
                Show    = $true
                Verbose = $true
            }
            Remove-Item -Path $ExcelParams.Path -Force -EA Ignore
            [PSCustOmobject][Ordered]@{
                Date      = Get-Date
                Formula1  = '=SUM(F2:G2)'
                String1   = 'My String'
                String2   = 'a'
                IPAddress = '10.10.25.5'
                Number1   = '07670'
                Number2   = '0,26'
                Number3   = '1.555,83'
                Number4   = '1.2'
                Number5   = '-31'
                PhoneNr1  = '+32 44'
                PhoneNr2  = '+32 4 4444 444'
                PhoneNr3  =  '+3244444444'
            } | Export-Excel @ExcelParams -NoNumberConversion IPAddress, Number1

            Exports all data to the Excel file 'Excel.xslx' and tries to convert all values to numbers where possible except for 'IPAddress' and 'Number1'. These are stored in the sheet 'as is', without being converted to a number.

        .EXAMPLE
        >
        PS> $ExcelParams = @{
                Path    = $env:TEMP + '\Excel.xlsx'
                Show    = $true
                Verbose = $true
            }
            Remove-Item -Path $ExcelParams.Path -Force -EA Ignore
            [PSCustOmobject][Ordered]@{
                Date      = Get-Date
                Formula1  = '=SUM(F2:G2)'
                String1   = 'My String'
                String2   = 'a'
                IPAddress = '10.10.25.5'
                Number1   = '07670'
                Number2   = '0,26'
                Number3   = '1.555,83'
                Number4   = '1.2'
                Number5   = '-31'
                PhoneNr1  = '+32 44'
                PhoneNr2  = '+32 4 4444 444'
                PhoneNr3  =  '+3244444444'
            } | Export-Excel @ExcelParams -NoNumberConversion *

            Exports all data to the Excel file 'Excel.xslx' as is, no number conversion will take place. This means that Excel will show the exact same data that you handed over to the 'Export-Excel' function.

        .EXAMPLE
        >
        PS> $ExcelParams = @{
                Path    = $env:TEMP + '\Excel.xlsx'
                Show    = $true
                Verbose = $true
            }
            Remove-Item -Path $ExcelParams.Path -Force -EA Ignore
            Write-Output 489 668 299 777 860 151 119 497 234 788 |
                Export-Excel @ExcelParams -ConditionalText $(
                    New-ConditionalText -ConditionalType GreaterThan 525 -ConditionalTextColor DarkRed -BackgroundColor LightPink
                )

            Exports data that will have a 'Conditional formatting rule' in Excel on these cells that will show the background fill color in 'LightPink' and the text color in 'DarkRed' when the value is greater then '525'. In case this condition is not met the color will be the default, black text on a white background.

        .EXAMPLE
        >
        PS> $ExcelParams = @{
                Path    = $env:TEMP + '\Excel.xlsx'
                Show    = $true
                Verbose = $true
            }
            Remove-Item -Path $ExcelParams.Path -Force -EA Ignore
            Get-Service | Select Name, Status, DisplayName, ServiceName |
                Export-Excel @ExcelParams -ConditionalText $(
                    New-ConditionalText Stop DarkRed LightPink
                    New-ConditionalText Running Blue Cyan
                )

            Export all services to an Excel sheet where all cells have a 'Conditional formatting rule' in Excel that will show the background fill color in 'LightPink' and the text color in 'DarkRed' when the value contains the word 'Stop'. If the value contains the word 'Running' it will have a background fill color in 'Cyan' and a text color 'Blue'. In case none of these conditions are met the color will be the default, black text on a white background.

        .EXAMPLE
        >
        PS> $ExcelParams = @{
                Path      = $env:TEMP + '\Excel.xlsx'
                Show      = $true
                Verbose   = $true
            }
            Remove-Item -Path $ExcelParams.Path -Force -EA Ignore

            $Array = @()

            $Obj1 = [PSCustomObject]@{
                Member1   = 'First'
                Member2   = 'Second'
            }

            $Obj2 = [PSCustomObject]@{
                Member1   = 'First'
                Member2   = 'Second'
                Member3   = 'Third'
            }

            $Obj3 = [PSCustomObject]@{
                Member1   = 'First'
                Member2   = 'Second'
                Member3   = 'Third'
                Member4   = 'Fourth'
            }

            $Array = $Obj1, $Obj2, $Obj3
            $Array | Out-GridView -Title 'Not showing Member3 and Member4'
            $Array | Update-FirstObjectProperties | Export-Excel @ExcelParams -WorksheetName Numbers

            Updates the first object of the array by adding property 'Member3' and 'Member4'. Afterwards. all objects are exported to an Excel file and all column headers are visible.

        .EXAMPLE
            Get-Process | Export-Excel .\test.xlsx -WorksheetName Processes -IncludePivotTable -Show -PivotRows Company -PivotData PM

        .EXAMPLE
            Get-Process | Export-Excel .\test.xlsx -WorksheetName Processes -ChartType PieExploded3D -IncludePivotChart -IncludePivotTable -Show -PivotRows Company -PivotData PM

        .EXAMPLE
            Get-Service | Export-Excel 'c:\temp\test.xlsx'  -Show -IncludePivotTable -PivotRows status -PivotData @{status='count'}

        .EXAMPLE
        >
        PS> $pt = [ordered]@{}
            $pt.pt1=@{ SourceWorkSheet   = 'Sheet1';
                       PivotRows         = 'Status'
                       PivotData         = @{'Status'='count'}
                       IncludePivotChart = $true
                       ChartType         = 'BarClustered3D'
            }
            $pt.pt2=@{ SourceWorkSheet   = 'Sheet2';
                       PivotRows         = 'Company'
                       PivotData         = @{'Company'='count'}
                       IncludePivotChart = $true
                       ChartType         = 'PieExploded3D'
            }
            Remove-Item  -Path .\test.xlsx
            Get-Service | Select-Object    -Property Status,Name,DisplayName,StartType | Export-Excel -Path .\test.xlsx -AutoSize
            Get-Process | Select-Object    -Property Name,Company,Handles,CPU,VM       | Export-Excel -Path .\test.xlsx -AutoSize -WorksheetName 'sheet2'
            Export-Excel -Path .\test.xlsx -PivotTableDefinition $pt -Show

            This example defines two pivot tables. Then it puts Service data on Sheet1 with one call to Export-Excel and Process Data on sheet2 with a second call to Export-Excel.
            The thrid and final call adds the two pivot tables and opens the spreadsheet in Excel.


        .EXAMPLE
        >
        PS> Remove-Item  -Path .\test.xlsx
            $excel = Get-Service | Select-Object -Property Status,Name,DisplayName,StartType | Export-Excel -Path .\test.xlsx -PassThru
            $excel.Workbook.Worksheets["Sheet1"].Row(1).style.font.bold = $true
            $excel.Workbook.Worksheets["Sheet1"].Column(3 ).width = 29
            $excel.Workbook.Worksheets["Sheet1"].Column(3 ).Style.wraptext = $true
            $excel.Save()
            $excel.Dispose()
            Start-Process .\test.xlsx

            This example uses -passthrough - put service information into sheet1 of the work book and saves the excelPackageObject in $Excel.
            It then uses the package object to apply formatting, and then saves the workbook and disposes of the object before loading the document in Excel.

        .EXAMPLE
        >
        PS> Remove-Item -Path .\test.xlsx -ErrorAction Ignore

            $excel = Get-Process | Select-Object -Property Name,Company,Handles,CPU,PM,NPM,WS | Export-Excel -Path .\test.xlsx -ClearSheet -WorksheetName "Processes" -PassThru
            $sheet = $excel.Workbook.Worksheets["Processes"]
            $sheet.Column(1) | Set-ExcelRange -Bold -AutoFit
            $sheet.Column(2) | Set-ExcelRange -Width 29 -WrapText
            $sheet.Column(3) | Set-ExcelRange -HorizontalAlignment Right -NFormat "#,###"
            Set-ExcelRange -Address $sheet.Cells["E1:H1048576"]  -HorizontalAlignment Right -NFormat "#,###"
            Set-ExcelRange -Address $sheet.Column(4)  -HorizontalAlignment Right -NFormat "#,##0.0" -Bold
            Set-ExcelRange -Address $sheet.Row(1) -Bold -HorizontalAlignment Center
            Add-ConditionalFormatting -WorkSheet $sheet -Range "D2:D1048576" -DataBarColor Red
            Add-ConditionalFormatting -WorkSheet $sheet -Range "G2:G1048576" -RuleType GreaterThan -ConditionValue "104857600" -ForeGroundColor Red
            foreach ($c in 5..9) {Set-ExcelRange -Address $sheet.Column($c)  -AutoFit }
            Export-Excel -ExcelPackage $excel -WorksheetName "Processes" -IncludePivotChart -ChartType ColumnClustered -NoLegend -PivotRows company  -PivotData @{'Name'='Count'}  -Show

            This a more sophisticated version of the previous example showing different ways of using Set-ExcelRange, and also adding conditional formatting.
            In the final command a Pivot chart is added and the workbook is opened in Excel.
        .EXAMPLE
             0..360 | ForEach-Object {[pscustomobject][ordered]@{X=$_; Sinx="=Sin(Radians(x)) "} } | Export-Excel -now -LineChart -AutoNameRange

             Creates a line chart showing the value of Sine(x) for values of X between 0 and 360 degrees.
        .LINK
            https://github.com/dfinke/ImportExcel
    #>
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    [OutputType([OfficeOpenXml.ExcelPackage])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingPlainTextForPassword", "")]
    Param(
        [Parameter(ParameterSetName = "Default", Position = 0)]
        [Parameter(ParameterSetName = "Table"  , Position = 0)]
        [String]$Path,
        [Parameter(Mandatory = $true, ParameterSetName = "PackageDefault")]
        [Parameter(Mandatory = $true, ParameterSetName = "PackageTable")]
        [OfficeOpenXml.ExcelPackage]$ExcelPackage,
        [Parameter(ValueFromPipeline = $true)]
        $TargetData,
        [Switch]$Calculate,
        [Switch]$Show,
        [String]$WorksheetName = 'Sheet1',
        [String]$Password,
        [switch]$ClearSheet,
        [switch]$Append,
        [String]$Title,
        [OfficeOpenXml.Style.ExcelFillStyle]$TitleFillPattern = 'Solid',
        [Switch]$TitleBold,
        [Int]$TitleSize = 22,
        [System.Drawing.Color]$TitleBackgroundColor,
        [Switch]$IncludePivotTable,
        [String]$PivotTableName,
        [String[]]$PivotRows,
        [String[]]$PivotColumns,
        $PivotData,
        [String[]]$PivotFilter,
        [Switch]$PivotDataToColumn,
        [Hashtable]$PivotTableDefinition,
        [Switch]$IncludePivotChart,
        [OfficeOpenXml.Drawing.Chart.eChartType]$ChartType = 'Pie',
        [Switch]$NoLegend,
        [Switch]$ShowCategory,
        [Switch]$ShowPercent,
        [Switch]$AutoSize,
        [Switch]$NoClobber,
        [Switch]$FreezeTopRow,
        [Switch]$FreezeFirstColumn,
        [Switch]$FreezeTopRowFirstColumn,
        [Int[]]$FreezePane,
        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'PackageDefault')]
        [Switch]$AutoFilter,
        [Switch]$BoldTopRow,
        [Switch]$NoHeader,
        [ValidateScript( {
                if (-not $_) {  throw 'RangeName is null or empty.'  }
                elseif ($_[0] -notmatch '[a-z]') { throw 'RangeName starts with an invalid character.'  }
                else { $true }
            })]
        [String]$RangeName,
        [ValidateScript( {
                if (-not $_) {  throw 'Tablename is null or empty.'  }
                elseif ($_[0] -notmatch '[a-z]') { throw 'Tablename starts with an invalid character.'  }
                else { $true }
            })]
        [Parameter(ParameterSetName = 'Table'        , Mandatory = $true, ValueFromPipelineByPropertyName)]
        [Parameter(ParameterSetName = 'PackageTable' , Mandatory = $true, ValueFromPipelineByPropertyName)]
        [String]$TableName,
        [Parameter(ParameterSetName = 'Table')]
        [Parameter(ParameterSetName = 'PackageTable')]
        [OfficeOpenXml.Table.TableStyles]$TableStyle = 'Medium6',
        [Switch]$Barchart,
        [Switch]$PieChart,
        [Switch]$LineChart ,
        [Switch]$ColumnChart ,
        [Object[]]$ExcelChartDefinition,
        [String[]]$HideSheet,
        [String[]]$UnHideSheet,
        [Switch]$MoveToStart,
        [Switch]$MoveToEnd,
        $MoveBefore ,
        $MoveAfter ,
        [Switch]$KillExcel,
        [Switch]$AutoNameRange,
        [Int]$StartRow = 1,
        [Int]$StartColumn = 1,
        [Switch]$PassThru,
        [String]$Numberformat = 'General',
        [string[]]$ExcludeProperty,
        [Switch]$NoAliasOrScriptPropeties,
        [Switch]$DisplayPropertySet,
        [String[]]$NoNumberConversion,
        [Object[]]$ConditionalFormat,
        [Object[]]$ConditionalText,
        [ScriptBlock]$CellStyleSB,
        #If there is already content in the workbook the sheet with the Pivot table will not be active UNLESS Activate is specified
        [switch]$Activate,
        [Parameter(ParameterSetName = 'Now')]
        [Switch]$Now,
        [Switch]$ReturnRange,
        #By default Pivot tables have Totals for each Row (on the right) and for each column at the bottom. This allows just one or neither to be selected.
        [ValidateSet("Both","Columns","Rows","None")]
        [String]$PivotTotals = "Both",
        #Included for compatibility - equivalent to -PivotTotals "None"
        [Switch]$NoTotalsInPivot,
        [Switch]$ReZip
    )

    Begin {
        $numberRegex = [Regex]'\d'
        function Add-CellValue {
            <#
              .SYNOPSIS
                Save a value in an Excel cell.

              .DESCRIPTION
                DateTime objects are always converted to a short DateTime format in Excel. When Excel loads the file,
                it applies the local format for dates. And formulas are always saved as formulas. URIs are set as hyperlinks in the file.

                Numerical values will be converted to numbers as defined in the regional settings of the local
                system. In case the parameter 'NoNumberConversion' is used, we don't convert to number and leave
                the value 'as is'. In case of conversion failure, we also leave the value 'as is'.
            #>

            Param (
                $TargetCell,
                $CellValue
            )
            #The write-verbose commands have been commented out below - even if verbose is silenced they cause a significiant performance impact and if it's on they will cause a flood of messages.
            Switch ($CellValue) {
                { $_ -is [DateTime]} {
                    # Save a date with one of Excel's built in formats format
                    $TargetCell.Value = $_
                    $TargetCell.Style.Numberformat.Format = 'm/d/yy h:mm' # This is not a custom format, but a preset recognized as date and localized.
                    #Write-Verbose  "Cell '$Row`:$ColumnIndex' header '$Name' add value '$_' as date"
                    break

                }
                { $_ -is [TimeSpan]} {
                    #Save a timespans with a built in format for elapsed hours, minutes and seconds
                    $TargetCell.Value = $_
                    $TargetCell.Style.Numberformat.Format = '[h]:mm:ss'
                    break
                }
                { $_ -is [System.ValueType]} {
                    # Save numerics, setting format if need be.
                    $TargetCell.Value = $_
                    if ($setNumformat) {$targetCell.Style.Numberformat.Format = $Numberformat }
                    #Write-Verbose  "Cell '$Row`:$ColumnIndex' header '$Name' add value '$_' as value"
                    break
                }
                {($_ -is [String]) -and ($_[0] -eq '=')} {
                    #region Save an Excel formula - we need = to spot the formula but the EPPLUS won't like it if we include it (Excel doesn't care if is there or not)
                    $TargetCell.Formula = ($_ -replace '^=','')
                    if ($setNumformat) {$targetCell.Style.Numberformat.Format = $Numberformat }
                    #Write-Verbose  "Cell '$Row`:$ColumnIndex' header '$Name' add value '$_' as formula"
                    break
                }
                { [System.Uri]::IsWellFormedUriString($_ , [System.UriKind]::Absolute) } {
                    # Save a hyperlink : internal links can be in the form xl://sheet!E419 (use A1 as goto sheet), or xl://RangeName
                    if ($_ -is [uri]) {$targetCell.HyperLink = $_ }
                    elseif ($_ -match "^xl://internal/") {
                          $referenceAddress = $_ -replace "^xl://internal/" , ""
                          $display          = $referenceAddress -replace "!A1$"   , ""
                          $h = New-Object -TypeName OfficeOpenXml.ExcelHyperLink -ArgumentList $referenceAddress , $display
                          $TargetCell.HyperLink = $h
                    }
                    else {$TargetCell.HyperLink = $_ }   #$TargetCell.Value = $_.AbsoluteUri
                    $TargetCell.Style.Font.Color.SetColor([System.Drawing.Color]::Blue)
                    $TargetCell.Style.Font.UnderLine = $true
                    #Write-Verbose  "Cell '$Row`:$ColumnIndex' header '$Name' add value '$($_.AbsoluteUri)' as Hyperlink"
                    break
                }
                {( $NoNumberConversion -and (
                  ($NoNumberConversion -contains $Name) -or ($NoNumberConversion -eq '*'))) } {
                    #Save text without it to converting to number
                    $TargetCell.Value = $_
                    #Write-Verbose "Cell '$Row`:$ColumnIndex' header '$Name' add value '$($TargetCell.Value)' unconverted"
                    break
                }
                Default {
                    #Save a value as a number if possible
                    $number = $null
                    if ($numberRegex.IsMatch($_) -and [Double]::TryParse($_, [System.Globalization.NumberStyles]::Any, [System.Globalization.NumberFormatInfo]::CurrentInfo, [Ref]$number)) {
                        # as simpler version using [Double]::TryParse( $_ , [ref]$number)) was found to cause problems reverted back to the longer version
                        $TargetCell.Value = $number
                        if ($setNumformat) {$targetCell.Style.Numberformat.Format = $Numberformat }
                        #Write-Verbose  "Cell '$Row`:$ColumnIndex' header '$Name' add value '$($TargetCell.Value)' as number converted from '$_' with format '$Numberformat'"
                    }
                    else {
                        $TargetCell.Value = $_
                        #Write-Verbose "Cell '$Row`:$ColumnIndex' header '$Name' add value '$($TargetCell.Value)' as string"
                    }
                    break
                }
            }
        }

        try {
            $script:Header = $null
            if ($Append -and $ClearSheet) {throw "You can't use -Append AND -ClearSheet."}

            if ($PSBoundParameters.Keys.Count -eq 0 -Or $Now) {
                $Path = [System.IO.Path]::GetTempFileName() -replace '\.tmp', '.xlsx'
                $Show = $true
                $AutoSize = $true
                if (!$TableName) {
                    $AutoFilter = $true
                }
            }

            if ($ExcelPackage) {
                $pkg = $ExcelPackage
                $Path = $pkg.File
            }
            Else { $pkg = Open-ExcelPackage -Path $Path -Create -KillExcel:$KillExcel -Password:$Password}
        }
        catch {throw "Could not open Excel Package $path"}
        if ($NoClobber) {Write-Warning -Message "-NoClobber parameter is no longer used" }
        try {
            $params = @{WorksheetName=$WorksheetName}
            foreach ($p in @("ClearSheet", "MoveToStart", "MoveToEnd", "MoveBefore", "MoveAfter", "Activate")) {if ($PSBoundParameters[$p]) {$params[$p] = $PSBoundParameters[$p]}}
            $ws = $pkg | Add-WorkSheet @params
            if ($ws.Name -ne $WorksheetName) {
                Write-Warning -Message "The Worksheet name has been changed from $WorksheetName to $($ws.Name), this may cause errors later."
                $WorksheetName = $ws.Name
            }
        }
        catch {throw "Could not get worksheet $worksheetname"}
        try {
            if ($Append -and $ws.Dimension) {
                #if there is a title or anything else above the header row, append needs to be combined wih a suitable startrow parameter
                $headerRange = $ws.Dimension.Address -replace "\d+$", $StartRow
                #using a slightly odd syntax otherwise header ends up as a 2D array
                $ws.Cells[$headerRange].Value | ForEach-Object -Begin {$Script:header = @()} -Process {$Script:header += $_ }
                #if we did not get AutoNameRange, but headers have ranges of the same name make autoNameRange True, otherwise make it false
                if (-not $AutoNameRange) {
                    $AutoNameRange  = $true ; foreach ($h in $header) {if ($ws.names.name -notcontains $h) {$AutoNameRange = $false} }
                }
                #if we did not get a Rangename but there is a Range which covers the active part of the sheet, set Rangename to that.
                if (-not $RangeName -and $ws.names.where({$_.name[0] -match '[a-z]'})) {
                    $theRange = $ws.names.where({
                         ($_.Name[0]   -match '[a-z]' )              -and
                         ($_.Start.Row    -eq $StartRow)             -and
                         ($_.Start.Column -eq $StartColumn)          -and
                         ($_.End.Row      -eq $ws.Dimension.End.Row) -and
                         ($_.End.Column   -eq $ws.Dimension.End.column) } , 'First', 1)
                    if ($theRange) {$rangename = $theRange.name}
                }

                #if we did not get a table name but there is a table which covers the active part of the sheet, set table name to that, and don't do anything with autofilter
                if (-not $TableName -and $ws.Tables.Where({$_.address.address -eq $ws.dimension.address})) {
                    $TableName  = $ws.Tables.Where({$_.address.address -eq $ws.dimension.address},'First', 1).Name
                    $AutoFilter = $false
                }
                #if we did not get $autofilter but a filter range is set and it covers the right area, set autofilter to true
                elseif (-not $AutoFilter -and $ws.Names['_xlnm._FilterDatabase']) {
                    if ( ($ws.Names['_xlnm._FilterDatabase'].Start.Row    -eq $StartRow)    -and
                         ($ws.Names['_xlnm._FilterDatabase'].Start.Column -eq $StartColumn) -and
                         ($ws.Names['_xlnm._FilterDatabase'].End.Row      -eq $ws.Dimension.End.Row) -and
                         ($ws.Names['_xlnm._FilterDatabase'].End.Column   -eq $ws.Dimension.End.Column) ) {$AutoFilter = $true}
                }

                $row = $ws.Dimension.End.Row
                Write-Debug -Message ("Appending: headers are " + ($script:Header -join ", ") + " Start row is $row")
            }
            elseif ($Title) {
                #Can only add a title if not appending!
                $Row = $StartRow
                $ws.Cells[$Row, $StartColumn].Value = $Title
                $ws.Cells[$Row, $StartColumn].Style.Font.Size = $TitleSize

                if ($TitleBold) {
                    #Set title to Bold face font if -TitleBold was specified.
                    #Otherwise the default will be unbolded.
                    $ws.Cells[$Row, $StartColumn].Style.Font.Bold = $True
                }
                if ($TitleBackgroundColor ) {
                    $ws.Cells[$Row, $StartColumn].Style.Fill.PatternType = $TitleFillPattern
                    $ws.Cells[$Row, $StartColumn].Style.Fill.BackgroundColor.SetColor($TitleBackgroundColor)
                }
                $Row ++ ; $startRow ++
            }
            else {  $Row = $StartRow }
            $ColumnIndex = $StartColumn
            $Numberformat = Expand-NumberFormat -NumberFormat $Numberformat
            if ((-not $ws.Dimension) -and ($Numberformat -ne $ws.Cells.Style.Numberformat.Format)) {
                    $ws.Cells.Style.Numberformat.Format = $Numberformat
                    $setNumformat = $false
            }
            else {  $setNumformat = ($Numberformat -ne $ws.Cells.Style.Numberformat.Format) }

            $firstTimeThru = $true
            $isDataTypeValueType = $false
      }
        catch {
            if ($AlreadyExists) {
                #Is this set anywhere ?
                throw "Failed exporting worksheet '$WorksheetName' to '$Path': The worksheet '$WorksheetName' already exists."
            }
            else {
                throw "Failed preparing to export to worksheet '$WorksheetName' to '$Path': $_"
            }
      }
    }

    Process {
        if ($TargetData) {
            try {
                if ($firstTimeThru) {
                    $firstTimeThru = $false
                    $isDataTypeValueType = $TargetData.GetType().name -match 'string|timespan|datetime|bool|byte|char|decimal|double|float|int|long|sbyte|short|uint|ulong|ushort|URI|ExcelHyperLink'
                    if ($isDataTypeValueType -and -not $Append) {$row -= 1} #row incremented before adding values, so it is set to the number of rows inserted at the end
                    Write-Debug "DataTypeName is '$($TargetData.GetType().name)' isDataTypeValueType '$isDataTypeValueType'"
                }

                if ($isDataTypeValueType) {
                    $ColumnIndex = $StartColumn
                    $Row += 1
                    try    {Add-CellValue -TargetCell $ws.Cells[$Row, $ColumnIndex] -CellValue $TargetData}
                    catch  {Write-Warning "Could not insert value at Row $Row. "}
                }
                else {
                    #region Add headers - if we are appending, or we have been through here once already we will have the headers
                    if (-not $script:Header) {
                        $ColumnIndex = $StartColumn
                        if ($DisplayPropertySet -and $TargetData.psStandardmembers.DefaultDisplayPropertySet.ReferencedPropertyNames) {
                            $script:Header = $TargetData.psStandardmembers.DefaultDisplayPropertySet.ReferencedPropertyNames.Where( {$_ -notin $ExcludeProperty})
                        }
                        else {
                            if ($NoAliasOrScriptPropeties) {$propType = "Property"} else {$propType = "*"}
                            $script:Header = $TargetData.PSObject.Properties.where( {$_.MemberType -like $propType}).Name
                        }
                        foreach ($exclusion in $ExcludeProperty) {$script:Header = $script:Header -notlike $exclusion}
                        if ($NoHeader) {
                            # Don't push the headers to the spreadsheet
                            $Row -= 1
                        }
                        else {
                            foreach ($Name in $script:Header) {
                                $ws.Cells[$Row, $ColumnIndex].Value = $Name
                                Write-Verbose "Cell '$Row`:$ColumnIndex' add header '$Name'"
                                $ColumnIndex += 1
                            }
                        }
                    }
                    #endregion
                    #region Add non header values
                    $Row += 1
                    $ColumnIndex = $StartColumn

                    foreach ($Name in $script:Header) {
                        try   {Add-CellValue -TargetCell $ws.Cells[$Row, $ColumnIndex] -CellValue $TargetData.$Name}
                        catch {Write-Warning -Message "Could not insert the $Name property at Row $Row, Column $Column"}
                        $ColumnIndex += 1
                    }
                    $ColumnIndex -= 1 # column index will be the last column whether isDataTypeValueType was true or false
                    #endregion
                }
            }
            catch {
                throw "Failed exporting data to worksheet '$WorksheetName' to '$Path': $_"
            }
        }
    }

    End {
        if ($firstTimeThru) {
              $LastRow      = $ws.Dimension.End.Row
              $LastCol      = $ws.Dimension.End.Column
              $endAddress   = $ws.Dimension.End.Address
        }
        else {
              $LastRow      = $Row
              $LastCol      = $ColumnIndex
              $endAddress   = [OfficeOpenXml.ExcelAddress]::GetAddress($LastRow , $LastCol)
        }
        $startAddress       = [OfficeOpenXml.ExcelAddress]::GetAddress($StartRow, $StartColumn)
        $dataRange          = "{0}:{1}" -f $startAddress, $endAddress

        Write-Debug "Data Range '$dataRange'"
        if ($AutoNameRange) {
            try {
                if (-not $script:header) {
                    # if there aren't any headers, use the the first row of data to name the ranges: this is the last point that headers will be used.
                    $headerRange = $ws.Dimension.Address -replace "\d+$", $StartRow
                    #using a slightly odd syntax otherwise header ends up as a 2D array
                    $ws.Cells[$headerRange].Value | ForEach-Object -Begin {$Script:header = @()} -Process {$Script:header += $_ }
                    #if there is no header start the range at $startRow
                    $targetRow = $StartRow
                }
                else {
                    #if there is a header, start the range and the next row down.
                    $targetRow = $StartRow + 1
                }

                #Dimension.start.row always seems to be one so we work out the target row
                #, but start.column is the first populated one and .Columns is the count of populated ones.
                # if we have 5 columns from 3 to 8, headers are numbered 0..4, so that is in the for loop and used for getting the name...
                # but we have to add the start column on when referencing positions
                foreach ($c in 0..($LastCol - $StartColumn)) {
                    $targetRangeName = $script:Header[$c] -replace '\W' , '_'
                    Add-ExcelName  -RangeName $targetRangeName -Range $ws.Cells[$targetRow, ($StartColumn + $c ), $LastRow, ($StartColumn + $c )]
                    if ([OfficeOpenXml.FormulaParsing.ExcelUtilities.ExcelAddressUtil]::IsValidAddress($targetRangeName)) {
                        Write-Warning "AutoNameRange: Property name '$targetRangeName' is also a valid Excel address and may cause issues. Consider renaming the property name."
                    }
                }
            }
            catch {Write-Warning -Message "Failed adding named ranges to worksheet '$WorksheetName': $_"  }
        }

        if ($RangeName) { Add-ExcelName  -Range $ws.Cells[$dataRange] -RangeName $RangeName}

        if ($TableName) {
            if ($PSBoundParameters.ContainsKey('TableStyle')) {
                  Add-ExcelTable -Range $ws.Cells[$dataRange] -TableName $TableName -TableStyle $TableStyle
            }
            else {Add-ExcelTable -Range $ws.Cells[$dataRange] -TableName $TableName}
        }

        if ($AutoFilter) {
            try {
                $ws.Cells[$dataRange].AutoFilter = $true
                Write-Verbose -Message "Enabled autofilter. "
            }
            catch {Write-Warning -Message "Failed adding autofilter to worksheet '$WorksheetName': $_"}
        }

        if ($PivotTableDefinition) {
            foreach ($item in $PivotTableDefinition.GetEnumerator()) {
                $params = $item.value
                if ($Activate) {$params.Activate = $true   }
                if ($params.keys -notcontains 'SourceRange' -and
                   ($params.Keys -notcontains 'SourceWorkSheet'   -or  $params.SourceWorkSheet -eq $WorksheetName)) {$params.SourceRange = $dataRange}
                if ($params.Keys -notcontains 'SourceWorkSheet')      {$params.SourceWorkSheet = $ws }
                if ($params.Keys -notcontains 'NoTotalsInPivot'   -and $NoTotalsInPivot  ) {$params.PivotTotals       = 'None'}
                if ($params.Keys -notcontains 'PivotTotals'       -and $PivotTotals      ) {$params.PivotTotals       = $PivotTotals}
                if ($params.Keys -notcontains 'PivotDataToColumn' -and $PivotDataToColumn) {$params.PivotDataToColumn = $true}

                Add-PivotTable -ExcelPackage $pkg -PivotTableName $item.key @Params
            }
        }
        if ($IncludePivotTable -or $IncludePivotChart) {
            $params = @{
                'SourceRange' = $dataRange
            }
            if ($PivotTableName -and ($pkg.workbook.worksheets.tables.name -contains $PivotTableName)) {
                Write-Warning -Message "The selected Pivot table name '$PivotTableName' is already used as a table name. Adding a suffix of 'Pivot'."
                $PivotTableName += 'Pivot'
            }

            if   ($PivotTableName)  {$params.PivotTableName    = $PivotTableName}
            else                    {$params.PivotTableName    = $WorksheetName + 'PivotTable'}
            if          ($Activate) {$params.Activate          = $true   }
            if       ($PivotFilter) {$params.PivotFilter       = $PivotFilter}
            if         ($PivotRows) {$params.PivotRows         = $PivotRows}
            if      ($PivotColumns) {$Params.PivotColumns      = $PivotColumns}
            if         ($PivotData) {$Params.PivotData         = $PivotData}
            if   ($NoTotalsInPivot) {$params.PivotTotals       = "None"    }
            Elseif   ($PivotTotals) {$params.PivotTotals       = $PivotTotals}
            if ($PivotDataToColumn) {$params.PivotDataToColumn = $true}
            if ($IncludePivotChart) {
                                     $params.IncludePivotChart = $true
                                     $Params.ChartType         = $ChartType
                if ($ShowCategory)  {$params.ShowCategory      = $true}
                if ($ShowPercent)   {$params.ShowPercent       = $true}
                if ($NoLegend)      {$params.NoLegend          = $true}
            }
            Add-PivotTable -ExcelPackage $pkg -SourceWorkSheet $ws   @params
        }

        try {
            #Allow single switch or two seperate ones.
            if ($FreezeTopRowFirstColumn -or ($FreezeTopRow -and $FreezeFirstColumn)) {
                $ws.View.FreezePanes(2, 2)
                Write-Verbose -Message "Froze top row and first column"
            }
            elseif ($FreezeTopRow) {
                $ws.View.FreezePanes(2, 1)
                Write-Verbose -Message "Froze top row"
            }
            elseif ($FreezeFirstColumn) {
                $ws.View.FreezePanes(1, 2)
                Write-Verbose -Message "Froze first column"
            }

            if ($FreezePane) {
                $freezeRow, $freezeColumn = $FreezePane
                if (-not $freezeColumn -or $freezeColumn -eq 0) {
                    $freezeColumn = 1
                }

                if ($freezeRow -gt 1) {
                    $ws.View.FreezePanes($freezeRow, $freezeColumn)
                    Write-Verbose -Message "Froze pandes at row $freezeRow and column $FreezeColumn"
                }
            }
        }
        catch {Write-Warning -Message "Failed adding Freezing the panes in worksheet '$WorksheetName': $_"}

        if ($BoldTopRow) { #it sets bold as far as there are populated cells: for whole row could do $ws.row($x).style.font.bold = $true
            try {
                if ($Title) {
                    $range = $ws.Dimension.Address -replace '\d+', ($StartRow + 1)
                }
                else {
                    $range = $ws.Dimension.Address -replace '\d+', $StartRow
                }
                $ws.Cells[$range].Style.Font.Bold = $true
                Write-Verbose -Message "Set $range font style to bold."
            }
            catch {Write-Warning -Message "Failed setting the top row to bold in worksheet '$WorksheetName': $_"}
        }
        if ($AutoSize) {
            try {
                $ws.Cells.AutoFitColumns()
                Write-Verbose -Message "Auto-sized columns"
            }
            catch {  Write-Warning -Message "Failed autosizing columns of worksheet '$WorksheetName': $_"}
        }

        foreach ($Sheet in $HideSheet) {
            try {
                $pkg.Workbook.WorkSheets.Where({$_.Name -like $sheet}) | ForEach-Object {
                    $_.Hidden = 'Hidden'
                    Write-verbose -Message "Sheet '$($_.Name)' Hidden."
                }
            }
            catch {Write-Warning -Message  "Failed hiding worksheet '$sheet': $_"}
        }
        foreach ($Sheet in $UnHideSheet) {
            try {
                $pkg.Workbook.WorkSheets.Where({$_.Name -like $sheet}) | ForEach-Object {
                    $_.Hidden = 'Visible'
                    Write-verbose -Message "Sheet '$($_.Name)' shown"
                }
            }
            catch {Write-Warning -Message  "Failed showing worksheet '$sheet': $_"}
        }
        if (-not $pkg.Workbook.Worksheets.Where({$_.Hidden -eq 'visible'})) {
            Write-Verbose -Message "No Sheets were left visible, making $WorksheetName visible"
            $ws.Hidden = 'Visible'
        }

        foreach ($chartDef in $ExcelChartDefinition) {
            if ($chartDef -is [System.Management.Automation.PSCustomObject]) {
                $params = @{}
                $chartDef.PSObject.Properties | ForEach-Object {if ( $null -ne $_.value) {$params[$_.name] = $_.value}}
                Add-ExcelChart -Worksheet $ws @params
            }
            elseif ($chartDef -is [hashtable] -or  $chartDef -is[System.Collections.Specialized.OrderedDictionary]) {
                Add-ExcelChart -Worksheet $ws @chartDef
            }
        }

        if ($Calculate) {
            try   { [OfficeOpenXml.CalculationExtension]::Calculate($ws) }
            catch { Write-Warning "One or more errors occured while calculating, save will continue, but there may be errors in the workbook. $_"}
        }

        if ($Barchart -or $PieChart -or $LineChart -or $ColumnChart) {
            if ($NoHeader) {$FirstDataRow = $startRow}
            else           {$FirstDataRow = $startRow + 1 }
            $range = [OfficeOpenXml.ExcelAddress]::GetAddress($FirstDataRow, $startColumn, $FirstDataRow, $lastCol )
            $xCol  = $ws.cells[$range] | Where-Object {$_.value -is [string]    } | ForEach-Object {$_.start.column} | Sort-Object | Select-Object -first 1
            if (-not $xcol) {
                $xcol  = $StartColumn
                $range = [OfficeOpenXml.ExcelAddress]::GetAddress($FirstDataRow, ($startColumn +1), $FirstDataRow, $lastCol )
            }
            $yCol  = $ws.cells[$range] | Where-Object {$_.value -is [valueType] -or $_.Formula } | ForEach-Object {$_.start.column} | Sort-Object | Select-Object -first 1
            if (-not ($xCol -and $ycol)) { Write-Warning -Message "Can't identify a string column and a number column to use as chart labels and data. "}
            else {
                $params = @{
                XRange = [OfficeOpenXml.ExcelAddress]::GetAddress($FirstDataRow, $xcol , $lastrow, $xcol)
                YRange = [OfficeOpenXml.ExcelAddress]::GetAddress($FirstDataRow, $ycol , $lastrow, $ycol)
                Title  =  ''
                Column = ($lastCol +1)
                Width  = 800
                }
                if   ($ShowPercent) {$params["ShowPercent"]  = $true}
                if  ($ShowCategory) {$params["ShowCategory"] = $true}
                if      ($NoLegend) {$params["NoLegend"]     = $true}
                if (-not $NoHeader) {$params["SeriesHeader"] = $ws.Cells[$startRow, $YCol].Value}
                if   ($ColumnChart) {$Params["chartType"]    = "ColumnStacked" }
                elseif  ($Barchart) {$Params["chartType"]    = "BarStacked"    }
                elseif  ($PieChart) {$Params["chartType"]    = "PieExploded3D" }
                elseif ($LineChart) {$Params["chartType"]    = "Line"          }

                Add-ExcelChart -Worksheet $ws @params
            }
        }

        # It now doesn't matter if the conditional formating rules are passed in $conditionalText or $conditional format.
        # Just one with an alias for compatiblity it will break things for people who are using both at once
        foreach ($c in  (@() + $ConditionalText  +  $ConditionalFormat) ) {
            try {
                #we can take an object with a .ConditionalType property made by New-ConditionalText or with a .Formatter Property made by New-ConditionalFormattingIconSet or a hash table
                if ($c.ConditionalType) {
                    $cfParams = @{RuleType = $c.ConditionalType;    ConditionValue = $c.Text ;
                           BackgroundColor = $c.BackgroundColor; BackgroundPattern = $c.PatternType  ;
                           ForeGroundColor = $c.ConditionalTextColor}
                    if ($c.Range) {$cfParams.Range = $c.Range}
                    else          {$cfParams.Range = $ws.Dimension.Address }
                    Add-ConditionalFormatting -WorkSheet $ws @cfParams
                    Write-Verbose -Message "Added conditional formatting to range $($c.range)"
                }
                elseif ($c.formatter)  {
                    switch ($c.formatter) {
                        "ThreeIconSet" {Add-ConditionalFormatting -WorkSheet $ws -ThreeIconsSet $c.IconType -range $c.range -reverse:$c.reverse  }
                        "FourIconSet"  {Add-ConditionalFormatting -WorkSheet $ws  -FourIconsSet $c.IconType -range $c.range -reverse:$c.reverse  }
                        "FiveIconSet"  {Add-ConditionalFormatting -WorkSheet $ws  -FiveIconsSet $c.IconType -range $c.range -reverse:$c.reverse  }
                    }
                    Write-Verbose -Message "Added conditional formatting to range $($c.range)"
                }
                elseif ($c -is [hashtable] -or  $c -is[System.Collections.Specialized.OrderedDictionary]) {
                    if (-not $c.Range) {$c.Range = $ws.Dimension.Address }
                    Add-ConditionalFormatting -WorkSheet $ws @c
                }
            }
            catch {throw "Error applying conditional formatting to worksheet $_"}
        }

        if ($CellStyleSB) {
            try {
                $TotalRows = $ws.Dimension.Rows
                $LastColumn = $ws.Dimension.Address -replace "^.*:(\w*)\d+$" , '$1'
                & $CellStyleSB $ws $TotalRows $LastColumn
            }
            catch {Write-Warning -Message "Failed processing CellStyleSB in worksheet '$WorksheetName': $_"}
        }

        if ($Password) {
            try {
                $ws.Protection.SetPassword($Password)
                Write-Verbose -Message 'Set password on workbook'
            }

            catch {throw "Failed setting password for worksheet '$WorksheetName': $_"}
        }

        if ($PassThru) {       $pkg   }
        else {
            if ($ReturnRange) {$dataRange }

            if ($Password) { $pkg.Save($Password) }
            else           { $pkg.Save() }
            Write-Verbose -Message "Saved workbook $($pkg.File)"
            if ($ReZip) {
                Write-Verbose -Message "Re-Zipping $($pkg.file) using .NET ZIP library"
                try {
                    Add-Type -AssemblyName 'System.IO.Compression.Filesystem' -ErrorAction stop
                }
                catch {
                    Write-Error "The -ReZip parameter requires .NET Framework 4.5 or later to be installed. Recommend to install Powershell v4+"
                    continue
                }
                try {
                    $TempZipPath = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath ([System.IO.Path]::GetRandomFileName())
                    [io.compression.zipfile]::ExtractToDirectory($pkg.File, $TempZipPath)  | Out-Null
                    Remove-Item $pkg.File -Force
                    [io.compression.zipfile]::CreateFromDirectory($TempZipPath, $pkg.File) | Out-Null
                }
                catch {throw "Error resizipping $path : $_"}
            }

            $pkg.Dispose()

            if ($Show) { Invoke-Item $Path }
        }

    }
}

function Add-WorkSheet  {
    <#
      .Synopsis
        Adds a workshet to an existing workbook.
      .Description
        If the named worksheet already exists, the -Clearsheet parameter decides whether it should be deleted and a new one returned,
        or if not specified the existing sheet will be returned. By default the sheet is created at the end of the work book, the
        -MoveXXXX switches allow the sheet to be [re]positioned at the start or before or after another sheet. A new sheet will only be
        made the default sheet when excel opens if -Activate is specified.
      .Example
        $WorksheetActors = $ExcelPackage | Add-WorkSheet -WorkSheetname Actors

        $ExcelPackage holds an Excel package object (returned by Open-ExcelPackage, or Export-Excel -passthru).
        This command will add a sheet named 'Actors', or return the sheet if it exists, and the result is stored in $WorkSheetActors.
      .Example
        $WorksheetActors = Add-WorkSheet -ExcelPackage $ExcelPackage -WorkSheetname "Actors" -ClearSheet -MoveToStart

        This time the Excel package object is passed as a parameter instead of piped. If the 'Actors' sheet already exists it is deleted
        and  re-created. The new sheet will be created last in the workbook, and -MoveToStart Moves it to the start.
      .Example
        $null = Add-WorkSheet -ExcelWorkbook $wb -WorkSheetname $DestinationName -CopySource  $sourceWs -Activate
        This time a workbook is used instead of a package, and a worksheet is copied - $SourceWs is a worksheet object, which can come
        from the same workbook or a different one. Here the new copy of the data is made the active sheet when the workbook is opened.
    #>
    [cmdletBinding()]
    [OutputType([OfficeOpenXml.ExcelWorksheet])]
    param(
        #An object representing an Excel Package.
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = "Package", Position = 0)]
        [OfficeOpenXml.ExcelPackage]$ExcelPackage,
        #An Excel workbook to which the Worksheet will be added - a package contains one workbook so you can use whichever fits at the time.
        [Parameter(Mandatory = $true, ParameterSetName = "WorkBook")]
        [OfficeOpenXml.ExcelWorkbook]$ExcelWorkbook,
        #The name of the worksheet 'Sheet1' by default.
        [string]$WorksheetName ,
        #If the worksheet already exists, by default it will returned, unless -ClearSheet is specified in which case it will be deleted and re-created.
        [switch]$ClearSheet,
        #If specified, the worksheet will be moved to the start of the workbook.
        #MoveToStart takes precedence over MoveToEnd, Movebefore and MoveAfter if more than one is specified.
        [Switch]$MoveToStart,
        #If specified, the worksheet will be moved to the end of the workbook.
        #(This is the default position for newly created sheets, but this can be used to move existing sheets.)
        [Switch]$MoveToEnd,
        #If specified, the worksheet will be moved before the nominated one (which can be a postion starting from 1, or a name).
        #MoveBefore takes precedence over MoveAfter if both are specified.
        $MoveBefore ,
        # If specified, the worksheet will be moved after the nominated one (which can be a postion starting from 1, or a name or *).
        # If * is used, the worksheet names will be examined starting with the first one, and the sheet placed after the last sheet which comes before it alphabetically.
        $MoveAfter ,
        #If there is already content in the workbook the new sheet will not be active UNLESS Activate is specified
        [switch]$Activate,
        #If worksheet is provided as a copy source the new worksheet will be a copy of it. The source can be in the same workbook, or in a different file.
        [OfficeOpenXml.ExcelWorksheet]$CopySource,
        #Ignored but retained for backwards compatibility.
        [Switch] $NoClobber
    )
    #if we were given a workbook use it, if we were given a package, use its workbook
    if      ($ExcelPackage -and -not $ExcelWorkbook) {$ExcelWorkbook = $ExcelPackage.Workbook}

    # If WorksheetName was given, try to use that worksheet. If it wasn't, and we are copying an existing sheet, try to use the sheet name
    # If we are not copying a sheet, and have no name, use the name "SheetX" where X is the number of the new sheet
    if      (-not $WorksheetName -and $CopySource -and -not $ExcelWorkbook[$CopySource.Name]) {$WorksheetName = $CopySource.Name}
    elseif  (-not $WorksheetName) {$WorksheetName = "Sheet" + (1 + $ExcelWorkbook.Worksheets.Count)}
    else    {$ws = $ExcelWorkbook.Worksheets[$WorksheetName]}

    #If -clearsheet was specified and the named sheet exists, delete it
    if      ($ws -and $ClearSheet) { $ExcelWorkbook.Worksheets.Delete($WorksheetName) ; $ws = $null }

    #Copy or create new sheet as needed
    if (-not $ws -and $CopySource) {
          Write-Verbose -Message "Copying into worksheet '$WorksheetName'."
          $ws = $ExcelWorkbook.Worksheets.Add($WorksheetName, $CopySource)
    }
    elseif (-not $ws) {
          $ws = $ExcelWorkbook.Worksheets.Add($WorksheetName)
          Write-Verbose -Message "Adding worksheet '$WorksheetName'."
    }
    else {Write-Verbose -Message "Worksheet '$WorksheetName' already existed."}
    #region Move sheet if needed
    if     ($MoveToStart) {$ExcelWorkbook.Worksheets.MoveToStart($WorksheetName) }
    elseif ($MoveToEnd  ) {$ExcelWorkbook.Worksheets.MoveToEnd($WorksheetName)   }
    elseif ($MoveBefore ) {
        if ($ExcelWorkbook.Worksheets[$MoveBefore]) {
            if ($MoveBefore -is [int]) {
                $ExcelWorkbook.Worksheets.MoveBefore($ws.Index, $MoveBefore)
            }
            else {$ExcelWorkbook.Worksheets.MoveBefore($WorksheetName, $MoveBefore)}
        }
        else {Write-Warning "Can't find worksheet '$MoveBefore'; worsheet '$WorksheetName' will not be moved."}
    }
    elseif ($MoveAfter  ) {
        if ($MoveAfter -eq "*") {
            if ($WorksheetName -lt $ExcelWorkbook.Worksheets[1].Name) {$ExcelWorkbook.Worksheets.MoveToStart($WorksheetName)}
            else {
                $i = 1
                While ($i -lt $ExcelWorkbook.Worksheets.Count -and ($ExcelWorkbook.Worksheets[$i + 1].Name -le $WorksheetName) ) { $i++}
                $ExcelWorkbook.Worksheets.MoveAfter($ws.Index, $i)
            }
        }
        elseif ($ExcelWorkbook.Worksheets[$MoveAfter]) {
            if ($MoveAfter -is [int]) {
                $ExcelWorkbook.Worksheets.MoveAfter($ws.Index, $MoveAfter)
            }
            else {
                $ExcelWorkbook.Worksheets.MoveAfter($WorksheetName, $MoveAfter)
            }
        }
        else {Write-Warning "Can't find worksheet '$MoveAfter'; worsheet '$WorksheetName' will not be moved."}
    }
    #endregion
    if ($Activate) {Select-Worksheet -ExcelWorksheet $ws  }
    if ($ExcelPackage -and -not (Get-Member -InputObject $ExcelPackage -Name $ws.Name)) {
        $sb = [scriptblock]::Create(('$this.workbook.Worksheets["{0}"]' -f $ws.name))
        Add-Member -InputObject $ExcelPackage -MemberType ScriptProperty -Name $ws.name -Value $sb
    }
    return $ws
}

function Select-Worksheet {
   <#
      .SYNOPSIS
        Sets the selected tab in an Excel workbook to be the chosen sheet, and unselects all the others.
      .DESCRIPTION
        Sometimes when a sheet is added we want it to be the active sheet, sometimes we want the active sheet to be left as it was.
        Select-Worksheet exists to change the which sheet is the selected tab when Excel opens the file.
      .EXAMPLE
        Select-Worksheet -ExcelWorkbook $ExcelWorkbook -WorksheetName "NewSheet"
        $ExcelWorkbook holds the a workbook object containing a sheet named "NewSheet";
        This sheet will become the [only] active sheet in the workbook
      .EXAMPLE
        Select-Worksheet -ExcelPackage $Pkg -WorksheetName "NewSheet2"
        $pkg holds an Excel Package, whose workbook contains a sheet named "NewSheet2"
        This sheet will become the [only] active sheet in the workbook
      .EXAMPLE
        Select-Worksheet -ExcelWorksheet $ws
        $ws holds an Excel worksheet which will become the [only] active sheet in the workbook
    #>
    param (
        #An object representing an Excel Package.
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'Package', Position = 0)]
        [OfficeOpenXml.ExcelPackage]$ExcelPackage,
        #An Excel workbook to which the Worksheet will be added - a package contains one workbook so you can use workbook or package as it suits
        [Parameter(Mandatory = $true, ParameterSetName = 'WorkBook')]
        [OfficeOpenXml.ExcelWorkbook]$ExcelWorkbook,
        [Parameter(ParameterSetName='Package')]
        [Parameter(ParameterSetName='Workbook')]
        #The name of the worksheet 'Sheet1' by default.
        [string]$WorksheetName,
        #An object representing an Excel worksheet
        [Parameter(ParameterSetName='Sheet',Mandatory=$true)]
        [OfficeOpenXml.ExcelWorksheet]$ExcelWorksheet
    )
    #if we were given a package, use its workbook
    if      ($ExcelPackage   -and -not $ExcelWorkbook) {$ExcelWorkbook  = $ExcelPackage.Workbook}
    #if we now have workbook, get the worksheet; if we were given a sheet get the workbook
    if      ($ExcelWorkbook  -and $WorksheetName)      {$ExcelWorksheet = $ExcelWorkbook.Worksheets[$WorksheetName]}
    elseif  ($ExcelWorksheet -and -not $ExcelWorkbook) {$ExcelWorkbook  = $ExcelWorksheet.Workbook ; }
    #if we didn't get to a worksheet give up. If we did set all works sheets to not selected and then the one we want to selected.
    if (-not $ExcelWorksheet) {Write-Warning -Message "The worksheet $WorksheetName was not found." ; return }
    else {
        foreach ($w in $ExcelWorkbook.Worksheets) {$w.View.TabSelected = $false}
        $ExcelWorksheet.View.TabSelected = $true
    }
}

Function Add-ExcelName {
    <#
      .SYNOPSIS
        Adds a named range to an existing Excel worksheet
      .DESCRIPTION
        It is often helpful to be able to refer to sets of cells with a name rather than using their co-ordinates; Add-ExcelName sets up these names.
      .EXAMPLE
          Add-ExcelName -Range $ws.Cells[$dataRange] -RangeName $rangeName
          $WS is a worksheet, and $dataRange is a string describing a range of cells - e.g. "A1:Z10"
          which will become a named range, using the name in $rangeName.
    #>
    [CmdletBinding()]
    param(
        #The range of cells to assign as a name.
        [Parameter(Mandatory=$true)]
        [OfficeOpenXml.ExcelRange]$Range,
        #The name to assign to the range. If the name exists it will be updated to the new range. If no name is specified the first cell in the range will be used as the name
        [String]$RangeName
    )
    try {
        $ws = $Range.Worksheet
        if (-not $RangeName) {
            $RangeName = $ws.Cells[$Range.Start.Address].Value
            $Range  = ($Range.Worksheet.cells[($range.start.row +1), $range.start.Column ,  $range.end.row, $range.end.column])
        }
        if ($RangeName -match '\W') {
            Write-Warning -Message "Range name '$RangeName' contains illegal characters, they will be replaced with '_'."
            $RangeName = $RangeName -replace '\W','_'
        }
        if ($ws.names[$RangeName]) {
            Write-verbose -Message "Updating Named range '$RangeName' to $($Range.FullAddressAbsolute)."
            $ws.Names[$RangeName].Address = $Range.FullAddressAbsolute
        }
        else  {
            Write-verbose -Message "Creating Named range '$RangeName' as $($Range.FullAddressAbsolute)."
            $ws.Names.Add($RangeName, $Range) | Out-Null
        }
    }
    catch {Write-Warning -Message "Failed adding named range '$RangeName' to worksheet '$($ws.Name)': $_"  }
}

function Add-ExcelTable {
    <#
      .SYNOPSIS
        Adds Tables to Excel workbooks.
      .DESCRIPTION
        Unlike named ranges, where the name only needs to be unique within a sheet, Table names must be unique in the workbook
        Tables carry formatting by default have a filter. The filter, header, Totals, first and last column highlights
      .EXAMPLE
        Add-ExcelTable -Range $ws.Cells[$dataRange] -TableName $TableName

        $WS is a worksheet, and $dataRange is a string describing a range of cells - e.g. "A1:Z10"
        this range which will become a table, named $TableName
      .EXAMPLE
        Add-ExcelTable -Range $ws.cells[$($ws.Dimension.address)] -TableStyle Light1 -TableName Musictable -ShowFilter:$false -ShowTotal -ShowFirstColumn
        Again $ws is a worksheet, range here is the whole of the active part of the worksheet. The table style and name are set,
        the filter is turned off, a totals row added and first column set in bold.
    #>
    [CmdletBinding()]
    [OutputType([OfficeOpenXml.Table.ExcelTable])]
    param (
        #The range of cells to assign to a table
        [Parameter(Mandatory=$true)]
        [OfficeOpenXml.ExcelRange]$Range,
        #The name for the table
        [Parameter(Mandatory=$true)]
        [String]$TableName,
        #The Style for the table, by default Medium 6
        [OfficeOpenXml.Table.TableStyles]$TableStyle = 'Medium6',
        #By default the header row is shown - it can be turned off with -ShowHeader:$false
        [Switch]$ShowHeader ,
        #By default the filter is enabled - it can be turned off with -ShowFilter:$false
        [Switch]$ShowFilter,
        #Show total adds a totals row. This does not automatically sum the columns but provides a drop-down in each to select sum, average etc
        [Switch]$ShowTotal,
        #Hashtable in the form ColumnName = "Average"|"Count"|"CountNums"|"Max"|"Min"|"None"|"StdDev"|"Sum"|"Var" - if specified ShowTotal is not needed.
        [hashtable]$TotalSettings,
        #Highlights the first column in bold
        [Switch]$ShowFirstColumn,
        #Highlights the last column in bold
        [Switch]$ShowLastColumn,
        #By default the table formats show striped rows, the can be turned off with -ShowRowStripes:$false
        [Switch]$ShowRowStripes,
        #Turns on column stripes.
        [Switch]$ShowColumnStripes,
        #If -PassThru is specified the table object will be returned to allow additional
        [Switch]$PassThru
    )
    try {
        if ($TableName -match "\W") {
            Write-Warning -Message "At least one character in $TableName is illegal in a table name and will be replaced with '_' . "
            $TableName = $TableName -replace '\W', '_'
        }
        $ws = $Range.Worksheet
        #if the table exists in this worksheet, update it.
        if ($ws.Tables[$TableName]) {
            $tbl =$ws.Tables[$TableName]
            $tbl.TableXml.table.ref = $Range.Address
            Write-Verbose -Message "Re-defined table '$TableName', now at $($Range.Address)."
        }
        elseif ($ws.Workbook.Worksheets.Tables.Name -contains $TableName) {
            Write-Warning -Message "The Table name '$TableName' is already used on a different worksheet."
            return
        }
        else {
            $tbl = $ws.Tables.Add($Range, $TableName)
            Write-Verbose -Message "Defined table '$TableName' at $($Range.Address)"
        }
        #it seems that show total changes some of the others, so the sequence matters.
        if     ($PSBoundParameters.ContainsKey('ShowHeader'))        {$tbl.ShowHeader        = [bool]$ShowHeader}
        if     ($PSBoundParameters.ContainsKey('TotalSettings'))     {
            $tbl.ShowTotal = $true
            foreach ($k in $TotalSettings.keys) {
                if (-not $tbl.Columns[$k]) {Write-Warning -Message "Table does not have a Column '$k'."}
                elseif ($TotalSettings[$k] -notin @("Average", "Count", "CountNums", "Max", "Min", "None", "StdDev", "Sum", "Var") ) {
                    Write-wanring "'$($TotalSettings[$k])' is not a valid total function."
                }
                else {$tbl.Columns[$k].TotalsRowFunction = $TotalSettings[$k]}
            }
        }
        elseif ($PSBoundParameters.ContainsKey('ShowTotal'))         {$tbl.ShowTotal         = [bool]$ShowTotal}
        if     ($PSBoundParameters.ContainsKey('ShowFilter'))        {$tbl.ShowFilter        = [bool]$ShowFilter}
        if     ($PSBoundParameters.ContainsKey('ShowFirstColumn'))   {$tbl.ShowFirstColumn   = [bool]$ShowFirstColumn}
        if     ($PSBoundParameters.ContainsKey('ShowLastColumn'))    {$tbl.ShowLastColumn    = [bool]$ShowLastColumn}
        if     ($PSBoundParameters.ContainsKey('ShowRowStripes'))    {$tbl.ShowRowStripes    = [bool]$ShowRowStripes}
        if     ($PSBoundParameters.ContainsKey('ShowColumnStripes')) {$tbl.ShowColumnStripes = [bool]$ShowColumnStripes}
        if     ($PSBoundParameters.ContainsKey('TableStyle'))        {$tbl.TableStyle        = $TableStyle}

        if ($PassThru) {return $tbl}
    }
    catch {Write-Warning -Message "Failed adding table '$TableName' to worksheet '$WorksheetName': $_"}
}