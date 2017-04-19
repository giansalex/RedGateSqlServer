SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_CotizacionFormatoCons]
@RucE nvarchar(11),
@TipCons int,
@msj varchar(100) output

as

if(@TipCons = 0) --CONSULTA GENERAL
begin
	select * from CotizacionFormato where RucE=@RucE	
end
else if (@TipCons = 1) --CONSULTA COMBOBOX
begin
	select Cd_FCt+'  |  '+Descrip as CodNom,Cd_FCt,Descrip from CotizacionFormato where RucE=@RucE and IB_Activo = 1
end
else if (@TipCons = 2)	--CONSULTA GENERAL CON ESTA ACTIVO
begin
	select * from CotizacionFormato where RucE=@RucE and IB_Activo = 1
end
else if (@TipCons = 3)	--CONSULTA PARA AYUDA
begin
	select Cd_FCt,Cd_FCt,Descrip from CotizacionFormato where RucE=@RucE and IB_Activo = 1
end

-- Leyenda --
-- DI : 11/03/2010 <Creacion del procedimiento almacenado>
GO
