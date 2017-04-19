SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
create procedure [user321].[Vta_OrdPedidoMdf_4]
@RucE nvarchar(11),--
@Cd_OP char(10),--
@NroOP varchar(50),--
@FecE smalldatetime,
@Cd_FPC nvarchar(2),
@Cd_Vdr char(7),
@Cd_Area nvarchar(6),
@Cd_Cte nvarchar(7),
@Cd_Clt char(10),
@DirecEnt varchar(200),
@FecEnt smalldatetime,
@Obs varchar(1000),
@Valor numeric(13,2),
@TotDsctoP numeric(5,2),
@TotDsctoI numeric(13,2),
@ValorNeto numeric(13,2),
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
@Cd_Mda nvarchar(2),
@CamMda numeric(6,2),
--@FecMdf datetime,
@UsuMdf nvarchar(10),
@Id_EstOP char(2),
@Cd_Cot char(10),
@CA01 varchar(8000),
@CA02 varchar(8000),
@CA03 varchar(8000),
@CA04 varchar(8000),
@CA05 varchar(8000),
@CA06 varchar(8000),
@CA07 varchar(8000),
@CA08 varchar(8000),
@CA09 varchar(8000),
@CA10 varchar(8000),
@TipAut int,
@Cd_CC nvarchar(8),
@Cd_SC nvarchar(8),
@Cd_SS nvarchar(8),
@AutorizadoPor varchar(100),
@msj varchar(100) output
as

if not exists (select * from OrdPedido where RucE=@RucE and Cd_OP=@Cd_OP and NroOP=@NroOP)
	Set @msj = 'Orden de Pedido no existe' 

else
begin 
 
	update OrdPedido set 	FecE = @FecE, Cd_FPC = @Cd_FPC, Cd_Vdr = @Cd_Vdr, Cd_Area = @Cd_Area, Cd_Cte = @Cd_Cte,
				Cd_Clt = @Cd_Clt, DirecEnt = @DirecEnt, FecEnt = @FecEnt, Obs = @Obs, Valor = @Valor,
				TotDsctoP = @TotDsctoP, TotDsctoI = @TotDsctoI, ValorNeto = @ValorNeto, INF = @INF,
				DsctoFnzInf_P = @DsctoFnzInf_P, DsctoFnzInf_I = @DsctoFnzInf_I, INF_Neto = @INF_Neto,
				BIM = @BIM, DsctoFnzAf_P = @DsctoFnzAf_P, DsctoFnzAf_I = @DsctoFnzAf_I, BIM_Neto = @BIM_Neto,
				IGV = @IGV, Total = @Total, Cd_Mda = @Cd_Mda, CamMda = @CamMda, FecMdf = getdate(),
				UsuMdf = @UsuMdf, Id_EstOP = @Id_EstOP, Cd_Cot = @Cd_Cot, CA01 = @CA01, CA02 = @CA02,
				CA03 = @CA03, CA04 = @CA04, CA05 = @CA05, CA06 = @CA06, CA07 = @CA07, CA08 = @CA08, CA09 = @CA09,
				CA10 = @CA10, TipAut = isnull(@TipAut,0), AutorizadoPor = @AutorizadoPor ,
				Cd_CC = @Cd_CC, Cd_SC = @Cd_SC, Cd_SS = @Cd_SS
			where RucE = @RucE and Cd_OP = @Cd_OP and NroOP = @NroOP
	if @@rowcount <= 0
		Set @msj = 'Error al modificar Orden de Compra'	
end
print @msj
--- Leyenda ---
--- FL: 04/08/2010 <creacion del sp>
--- JV: 03/12/2012 <Adecuación a 7 decimales>
-- CAM: 29/01/2013 <cambiar la longitud del campo @DirecEnt>
GO
