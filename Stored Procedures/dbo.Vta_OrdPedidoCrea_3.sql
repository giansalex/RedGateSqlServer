SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROC [dbo].[Vta_OrdPedidoCrea_3]
        	@RucE nvarchar(11),
        	@Cd_OP char(10) output,
        	@NroOP varchar(50),
        	@FecE smalldatetime,
        	@Cd_FPC nvarchar(2),
        	@Cd_Vdr char(7),
        	@Cd_Area nvarchar(6),
        	@Cd_Cte nvarchar(7),
			@Cd_Clt nvarchar(10),
        	@DirecEnt varchar(200),
        	@FecEnt smalldatetime,
        	@Obs varchar(1000),
        	@Valor numeric(18,7),
        	@TotDsctoP numeric(5,2),
        	@TotDsctoI numeric(18,7),
        	@ValorNeto numeric(18,7),
        	@INF numeric(18,7),
        	@DsctoFnzInf_P numeric(5,2),
        	@DsctoFnzInf_I numeric(18,7),
        	@INF_Neto numeric(18,7),
        	@BIM numeric(18,7),
        	@DsctoFnzAf_P numeric(5,2),
        	@DsctoFnzAf_I numeric(18,7),
        	@BIM_Neto numeric(18,7),
        	@IGV numeric(18,7),
        	@Total numeric(18,7),
        	@Cd_Mda nvarchar(2),
        	@CamMda numeric(6,3),
        	--@FecReg datetime,
        	--@FecMdf datetime,
        	@UsuCrea nvarchar(10),
        	--@UsuMdf nvarchar(10),
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
			@msj varchar(100) output,
			@FecVencimiento date
        	as
        
    if exists (select * from OrdPedido where RucE = @RucE and NroOP = @NroOP)
    begin
		set @msj = 'El numero de la orden de pedido ya fue registrado.'
		return
	end
	
	Set @Cd_OP = dbo.Cd_OP(@RucE)	
        	if exists (select * from OrdPedido where RucE=@RucE and Cd_OP=@Cd_OP and NroOP=@NroOP)
	Set @msj = 'Ya existe numero de orden de pedido'

	else
	begin 
	insert into OrdPedido(RucE,Cd_OP,NroOP,FecE,Cd_FPC,Cd_Vdr,Cd_Area,Cd_Cte,DirecEnt,FecEnt,Obs,Valor,TotDsctoP,TotDsctoI,ValorNeto,
        			  INF,DsctoFnzInf_P,DsctoFnzInf_I,INF_Neto,BIM,DsctoFnzAf_P,DsctoFnzAf_I,BIM_Neto,IGV,Total,Cd_Mda,CamMda,
		        	  FecReg,UsuCrea,Id_EstOP,Cd_Cot,TipAut,IB_Aut,CA01,CA02,CA03,CA04,CA05,CA06,CA07,CA08,CA09,CA10,Cd_Clt,Cd_CC,Cd_SC,Cd_SS,FecVencimiento)
	values(@RucE,@Cd_OP,@NroOP,@FecE,@Cd_FPC,@Cd_Vdr,@Cd_Area,@Cd_Cte,@DirecEnt,@FecEnt,@Obs,@Valor,@TotDsctoP,@TotDsctoI,@ValorNeto,
        			  @INF,@DsctoFnzInf_P,@DsctoFnzInf_I,@INF_Neto,@BIM,@DsctoFnzAf_P,@DsctoFnzAf_I,@BIM_Neto,@IGV,@Total,@Cd_Mda,@CamMda,
		        	  getdate(),@UsuCrea,'01',@Cd_Cot,isnull(@TipAut,0),0, @CA01,@CA02,@CA03,@CA04,@CA05,@CA06,@CA07,@CA08,@CA09,@CA10,@Cd_Clt,@Cd_CC,@Cd_SC,@Cd_SS,@FecVencimiento)
	if @@rowcount <= 0
		Set @msj = 'Error al registrar orden de pedido'
	end
	--- Leyenda ---
	--- FL: 04/08/2010 <creacion del sp>
	--- JV: 03/12/2012 <Adecuación a 7 decimales>
	-- CAM: 29/01/2013 <cambiar la longitud del campo @DirecEnt>
GO
