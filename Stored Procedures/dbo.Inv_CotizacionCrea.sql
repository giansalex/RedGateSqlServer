SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Inv_CotizacionCrea]
/*
exec sp_help cliente2
Declare @msj varchar(100)
exec Inv_CotizacionCrea 
'11111111111',null,'NRO-00000000071','06/08/2010',null,'01',null,null,'CLT0000003','VND0001',
null,null,null,null,null,null,null,null,
null,null,null,null,null,null,
null,null,null,null,null,null,
'Diego',null,null,
null,null,null,null,null,@msj out
print @msj
*/

@RucE nvarchar(11),
@Cd_Cot char(10) output,
@NroCot varchar(15),
@FecEmi smalldatetime,
@FecCad smalldatetime,
@Cd_FPC nvarchar(2),
@Asunto varchar(200),
@Cd_Cte nvarchar(7),
@Cd_Clt char(10),
@Cd_Vdr char(7),
@CostoTot numeric(13,2),
@Valor numeric(13, 2),
@TotDsctoP numeric(5,2),
@TotDsctoI numeric(13,2),
@INF numeric(13,2),
@DsctoFnzInf_P numeric(5,2),
@DsctoFnzInf_I numeric(13,2),
@INF_Neto numeric(13,2),
@BIM numeric(13,2),
@DsctoFnzAf_P numeric(5,2),
@DsctoFnzAf_I numeric(13,2),
@BIM_Neto numeric(13,2),
@IGV numeric(13,2),
@Total numeric(13,2),
@MU_Porc numeric(13,2),
@MU_Imp numeric(13,2),
@Cd_Mda nvarchar(2),
@CamMda numeric(6,3),
@Cd_Area nvarchar(6),
@Obs varchar(1000),
--@FecReg datetime,
--@FecMdf datetime,
@UsuCrea nvarchar(10),
--@UsuMdf nvarchar(10),
@CdCot_Base char(10),
--@Id_EstC char(2),
@Cd_FCt char(2),
@CA01 varchar(100),
@CA02 varchar(100),
@CA03 varchar(100),
@CA04 varchar(100),
@CA05 varchar(100),

@Cd_CC varchar(8),
@Cd_SC varchar(8),
@Cd_SS varchar(8),

@msj varchar(100) output

as

--@Cd_Cte Codigo de Homologacion de Auxiliar a Cliente2
--declare @Cd_Cte nvarchar(7)
set @Cd_Cte = (select cl.Cd_Aux from Cliente2 cl where cl.RucE = @RucE and cl.Cd_Clt = @Cd_Clt) 
print @Cd_Cte

if exists (select * from Cotizacion where RucE=@RucE and NroCot=@NroCot)
	Set @msj = 'Ya existe numero de cotizacion'
else
begin
	Set @Cd_Cot = user123.Cod_Cot(@RucE) --Obteniendo el codigo de cotizacion

	insert into Cotizacion(RucE,Cd_Cot,NroCot,FecEmi,FecCad,Cd_FPC,Asunto,Cd_Cte,Cd_Clt,Cd_Vdr,
			       CostoTot,Valor,TotDsctoP,TotDsctoI,INF,DsctoFnzInf_P,DsctoFnzInf_I,INF_Neto,BIM,
			       DsctoFnzAf_P,DsctoFnzAf_I,BIM_Neto,IGV,Total,
			       MU_Porc,MU_Imp,Cd_Mda,CamMda,Cd_Area,Obs,FecReg,UsuCrea,CdCot_Base,
			       Id_EstC,Cd_FCt,CA01,CA02,CA03,CA04,CA05,Cd_CC,Cd_SC,Cd_SS)
			Values(@RucE,user123.Cod_Cot(@RucE),@NroCot,@FecEmi,@FecCad,@Cd_FPC,@Asunto,@Cd_Cte,@Cd_Clt,@Cd_Vdr,
			       @CostoTot,@Valor,@TotDsctoP,@TotDsctoI,@INF,@DsctoFnzInf_P,@DsctoFnzInf_I,@INF_Neto,
			       @BIM,@DsctoFnzAf_P,@DsctoFnzAf_I,@BIM_Neto,@IGV,@Total,
			       @MU_Porc,@MU_Imp,@Cd_Mda,@CamMda,@Cd_Area,@Obs,getdate(),@UsuCrea,@CdCot_Base,
			       '01',@Cd_FCt,@CA01,@CA02,@CA03,@CA04,@CA05,@Cd_CC,@Cd_SC,@Cd_SS)
	if @@rowcount <= 0
		Set @msj = 'Error al registrar cotizacion'
end

-- Leyeda --
-- DI : 04/03/2010 : <Creacion del procedimiento almacenado>
-- JU : 09/08/2010 : <Modificacion del procedimiento almacenado>
-- DI : 13/12/2010 : <Se agrego los campos de CC,SC,SS>


GO
