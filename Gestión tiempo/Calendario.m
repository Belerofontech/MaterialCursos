let
    // configurations start
    Today = Date.From( DateTime.LocalNow() ), // today's date
    FromYear = 2011, // set the start year of the date dimension. dates start from 1st of January of this year
    ToYear = 2015, // set the end year of the date dimension. dates end at 31st of December of this year
    firstDayofWeek = Day.Monday, // set the week's start day, values: Day.Monday, Day.Sunday....
    // configuration end
    
    FromDate = #date(FromYear, 1, 1),
    ToDate = #date(ToYear, 12, 31),
    Source = 
        List.Dates(
            FromDate,
            Duration.Days( ToDate - FromDate ) + 1,
            #duration(1, 0, 0, 0)
        ),
    Covertir_a_Tabla = Table.FromList(Source, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    Columnas_Renombradas = Table.RenameColumns(Covertir_a_Tabla,{{"Column1", "Fecha"}}),
    Tipo_Cambiado = Table.TransformColumnTypes(Columnas_Renombradas,{{"Fecha", type date}}),
    Año_Insertado = Table.AddColumn(Tipo_Cambiado, "Año", each Date.Year([Fecha]), Int64.Type),
    #"Trimestre insertado" = Table.AddColumn(Año_Insertado, "Trimestre", each Date.QuarterOfYear([Fecha]), Int64.Type),
    #"Mes insertado" = Table.AddColumn(#"Trimestre insertado", "Mes", each Date.Month([Fecha]), Int64.Type),
    #"Fin de mes insertado" = Table.AddColumn(#"Mes insertado", "Fin de mes", each Date.EndOfMonth([Fecha]), type date),
    #"Semana del año insertada" = Table.AddColumn(#"Fin de mes insertado", "Semana del año", each Date.WeekOfYear([Fecha]), Int64.Type),
    #"Día insertado" = Table.AddColumn(#"Semana del año insertada", "Día", each Date.Day([Fecha]), Int64.Type),
    #"Nombre del día insertado" = Table.AddColumn(#"Día insertado", "Nombre del día", each Date.DayOfWeekName([Fecha]), type text),
    Salida = Table.AddColumn(#"Nombre del día insertado", "Día de la semana", each Date.DayOfWeek([Fecha], firstDayofWeek ), Int64.Type)
in
    Salida