SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [pvo].[Vta_VentaConsUn_ConDet] --Consulta una venta con su detalle
@RucE 	nvarchar(11),
@Eje 	nvarchar(4),
@Cd_TD 	nvarchar(2),
@NroSre	nvarchar(4),
@NroDoc nvarchar(15),
@RegCtb nvarchar(15),
--@UsuModf  nvarchar(10),
@msj 	varchar(100) output
as

--select * from Venta
--select * from Serie



--exec sp_help 'Venta'

declare @Cd_Vta nvarchar(10)

if @RegCtb is not null and @RegCtb!=''
begin

	if exists (select Cd_Vta from Venta where RucE=@RucE and Eje=@Eje and RegCtb=@RegCtb)
	begin
		
		--select * from Venta where RucE=@RucE and Eje=@Eje and RegCtb=@RegCtb

		select @Cd_Vta=Cd_Vta from Venta where RucE=@RucE and Eje=@Eje and RegCtb=@RegCtb

		exec pvo.Vta_VentaConsUn @RucE,@Cd_Vta,null
		select * from ventaDet where RucE= @RucE and Cd_Vta=@Cd_Vta
		select Cd_Cp, Valor from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta

	end

	else
	begin
		set @msj = 'No existe una venta con ese numero de reg. contable'
		--return
	end
	

end



else if @Cd_TD is not null and @Cd_TD!='' and @NroSre is not null and @NroSre!='' and @NroDoc is not null and @NroDoc!='' 

begin
	declare @Cd_Sr nvarchar(4)
	set @Cd_Sr = (select Cd_Sr from Serie where RucE=@RucE and Cd_TD=@Cd_TD and NroSerie=@NroSre)
	
	
	if exists (select Cd_Vta from Venta where RucE=@RucE and Cd_TD=@Cd_TD and Cd_Sr=@Cd_Sr and NroDoc=@NroDoc) 
	begin
		
		--select * from Venta where RucE=@RucE /*and Eje=@Ejer*/ and Cd_TD=@Cd_TD and Cd_Sr=@Cd_Sr and NroDoc=@NroDoc

		select @Cd_Vta=Cd_Vta from Venta where RucE=@RucE /*and Eje=@Ejer*/ and Cd_TD=@Cd_TD and Cd_Sr=@Cd_Sr and NroDoc=@NroDoc

		exec pvo.Vta_VentaConsUn @RucE,@Cd_Vta,null
		select * from ventaDet where RucE= @RucE and Cd_Vta=@Cd_Vta
		select Cd_Cp, Valor from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta

	end
	else
	begin
		set @msj = 'No existe venta con serie y número de documento especificado'
		--return
	
	end

end
else
begin
	set @msj = 'No se especifico ningun reg. ctb. o numero de doc.'
	--return
end

print @msj


--Pruebas:
/*
exec pvo.Vta_VentaConsUn_ConDet '11111111111', '2010','','','','VTGE_RV02-00003',null
exec pvo.Vta_VentaConsUn_ConDet '11111111111', '2010','01','0001','0000062','',null

exec pvo.Vta_VentaConsUn_ConDet '11111111111', '2010','','','','',null
*/


--PV: LUN 02/02/2010: Creado -->
GO
