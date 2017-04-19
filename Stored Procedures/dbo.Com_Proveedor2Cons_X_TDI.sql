SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Com_Proveedor2Cons_X_TDI]
@RucE nvarchar(11),
@Cd_TDI nvarchar(2),
@TipCons int,
@msj varchar(100) output
as
begin
	if(@TipCons=0)
		select * from Proveedor2 where RucE=@RucE and Cd_TDI = @Cd_TDI
	else if (@TipCons=1) 
		select case(isnull(len(RSocial),0)) when 0 then NDoc+'  |  '+ApPat+' '+ApMat+' '+Nom else NDoc+'  |  '+RSocial end as CodNom, Cd_Prv from Proveedor2 where RucE=@RucE and Estado=1 and Cd_TDI = @Cd_TDI
	else if (@TipCons=2)
		select * from Proveedor2 where RucE=@RucE and Cd_TDI = @Cd_TDI and Estado =1
	else if (@TipCons=3)
	   	select Cd_Prv, NDoc, case(isnull(len(RSocial),0)) when 0 then ApPat+' '+ApMat+' '+Nom else RSocial end as Nombre from Proveedor2 where RucE=@RucE and Cd_TDI = @Cd_TDI and Estado=1
end
print @msj

-- Leyenda --
-- PP : 2010-07-21 11:13:55.617	: <Creacion del procedimiento almacenado>
-- CAM: 2011-07-20 15:15:00.000 : <Se modifico para que las ayudas solo muestren los habilitados> Se comento
GO
