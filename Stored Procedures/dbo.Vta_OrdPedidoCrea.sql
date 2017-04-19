SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Vta_OrdPedidoCrea]
        	@RucE nvarchar(11),
        	@Cd_OP char(10) output,
        	@NroOP varchar(50),
        	@FecE smalldatetime,
        	@Cd_FPC nvarchar(2),
        	@Cd_Vdr char(7),
        	@Cd_Area nvarchar(6),
        	@Cd_Cte nvarchar(7),
	@Cd_Clt nvarchar(10),
        	@DirecEnt varchar(100),
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
        	@CamMda numeric(6,3),
        	--@FecReg datetime,
        	--@FecMdf datetime,
        	@UsuCrea nvarchar(10),
        	--@UsuMdf nvarchar(10),
        	@Id_EstOP char(2),
        	@Cd_Cot char(10),
        	@CA01 nvarchar(100),
        	@CA02 nvarchar(100),
        	@CA03 nvarchar(100),
        	@CA04 nvarchar(100),
        	@CA05 nvarchar(100),
        	@CA06 nvarchar(100),
        	@CA07 nvarchar(100),
        	@CA08 nvarchar(100),
        	@CA09 nvarchar(300),
        	@CA10 nvarchar(300),
        	@msj varchar(100) output
         
        	as
        
	Set @Cd_OP = dbo.Cd_OP(@RucE)	
        	if exists (select * from OrdPedido where RucE=@RucE and Cd_OP=@Cd_OP and NroOP=@NroOP)
	Set @msj = 'Ya existe numero de orden de pedido'

	else
	begin 
	insert into OrdPedido(RucE,Cd_OP,NroOP,FecE,Cd_FPC,Cd_Vdr,Cd_Area,Cd_Cte,DirecEnt,FecEnt,Obs,Valor,TotDsctoP,TotDsctoI,ValorNeto,
        			  INF,DsctoFnzInf_P,DsctoFnzInf_I,INF_Neto,BIM,DsctoFnzAf_P,DsctoFnzAf_I,BIM_Neto,IGV,Total,Cd_Mda,CamMda,
		        	  FecReg,UsuCrea,Id_EstOP,Cd_Cot,CA01,CA02,CA03,CA04,CA05,CA06,CA07,CA08,CA09,CA10,Cd_Clt)
	values(@RucE,@Cd_OP,@NroOP,@FecE,@Cd_FPC,@Cd_Vdr,@Cd_Area,@Cd_Cte,@DirecEnt,@FecEnt,@Obs,@Valor,@TotDsctoP,@TotDsctoI,@ValorNeto,
        			  @INF,@DsctoFnzInf_P,@DsctoFnzInf_I,@INF_Neto,@BIM,@DsctoFnzAf_P,@DsctoFnzAf_I,@BIM_Neto,@IGV,@Total,@Cd_Mda,@CamMda,
		        	  getdate(),@UsuCrea,'01',@Cd_Cot,@CA01,@CA02,@CA03,@CA04,@CA05,@CA06,@CA07,@CA08,@CA09,@CA10,@Cd_Clt)
	if @@rowcount <= 0
		Set @msj = 'Error al registrar orden de pedido'
	end
	--- Leyenda ---
	--- FL: 04/08/2010 <creacion del sp>
GO
