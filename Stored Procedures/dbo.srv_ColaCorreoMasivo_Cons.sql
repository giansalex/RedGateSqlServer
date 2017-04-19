SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[srv_ColaCorreoMasivo_Cons] As
Declare @consulta1 nvarchar(1000)
Declare @consulta2 nvarchar(1000)
Declare @consulta3 nvarchar(1000)

Declare @condicion nvarchar(100)
Set @consulta1 = 'Select RucE,TareaProgramadaID,Correo As Destinatario,Hora1 As Hora From TareaProgramada Where ((FechaFin >= getdate() and FechaInicio <= getdate()) or EsRecurrente = 1)'
print @consulta1
Set @consulta2 = 'Select RucE,TareaProgramadaID,Correo As Destinatario,Hora2 As Hora From TareaProgramada Where ((FechaFin >= getdate() and FechaInicio <= getdate()) or EsRecurrente = 1)'
print @consulta2
Set @consulta3 = 'Select RucE,TareaProgramadaID,Correo As Destinatario,Hora3 As Hora From TareaProgramada Where ((FechaFin >= getdate() and FechaInicio <= getdate()) or EsRecurrente = 1)'
print @consulta3
Set @condicion = case(select Datename(dw,getdate()))
	when 'Lunes' then
		 ' and SoloLunes = 1'
	when 'Martes' then
		' and SoloMartes = 1'
	when 'Miércoles' then
		' and SoloMiercoles = 1'
	when 'Jueves' then
		' and SoloJueves = 1'
	when 'Viernes' then
		' and SoloViernes = 1'
	when 'Sábado' then
		' and SoloSabados = 1'
	when 'Domingo' then
		' and SoloDomingos = 1'
	end
print @condicion
Set @consulta1 = ltrim(rtrim(@consulta1)) + rtrim(@condicion)
print @consulta1
Set @consulta2 = ltrim(rtrim(@consulta2)) + rtrim(@condicion)
print @consulta2
Set @consulta3 = ltrim(rtrim(@consulta3)) + rtrim(@condicion)
print @consulta3
Declare @consulta nvarchar(3000)
Set @consulta = 'Select RucE,TareaProgramadaID,Destinatario,Hora, 1 As Tipo From ('+ ltrim(rtrim(@consulta1)) + ' union ' + ltrim(rtrim(@consulta2)) + ' union ' + ltrim(rtrim(@consulta3)) +') As x Where Hora >=CONVERT(TIME,GETDATE()) Order By Hora Asc'
print @consulta
Exec(@consulta)
GO
