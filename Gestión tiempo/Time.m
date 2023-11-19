let
    Source = List.Times( #time(0, 0, 0), 24 * 60 * 60, #duration(0, 0, 0, 1 ) ),
    Convertir_a_Tabla = Table.FromList(Source, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    Renombrar_Columnas = Table.RenameColumns(Convertir_a_Tabla,{{"Column1", "Time"}}),
    Cambio_Tipo = Table.TransformColumnTypes(Renombrar_Columnas,{{"Time", type time}}),
    Insercion_Hora = Table.AddColumn(Cambio_Tipo, "Hora", each Time.Hour([Time]), Int64.Type),
    Insercion_Minuto = Table.AddColumn(Insercion_Hora, "Minuto", each Time.Minute([Time]), Int64.Type),
    Insercion_Segundo = Table.AddColumn(Insercion_Minuto, "Segundo", each Time.Second([Time]), Int64.Type),
    Columna_Condicional = Table.AddColumn(Insercion_Segundo, "AM/PM", each if [Hora] < 12 then "AM" else "PM"),
    Tipo_Cambiado = Table.TransformColumnTypes(Columna_Condicional,{{"AM/PM", type text}})
in
    Tipo_Cambiado