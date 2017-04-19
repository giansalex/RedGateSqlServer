SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create PROC [dbo].[Prd_OrdFabricacionCrea_3]
        	@RucE nvarchar(11),
        	@Cd_OF char(10) output,
        	@NroOF varchar(50),
        	@FecE smalldatetime,
		@FecEntR smalldatetime,
		@Cd_Area nvarchar(6),
		@Cd_Prod char(7),
        	@Cd_Alm varchar(20),
		@ID_UMP int,     	
        	@Asunto varchar(200),
		@Obs varchar(1000),
		@Lote varchar(100),
		@CosTot numeric(15, 7),
		@Cant numeric(15, 7),
		@CU numeric(15, 7),
		@Cd_Mda nvarchar(2),
		@CamMda numeric(6,3),
		@FecReg smalldatetime,
		@FecMdf smalldatetime,
        	@UsuCrea nvarchar(10),
		@UsuModf nvarchar(10),
		@Cd_CC nvarchar(8),
		@Cd_SC nvarchar(8),
		@Cd_SS nvarchar(8),
		@Id_EstOF char(2),
		@TipAut int,
		@IB_Aut bit,
		@AutorizadoPor varchar(200),
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
			@ID_Fmla int,
        	@msj varchar(100) output,
        	@CdOF_Base char(10),
        	@CU_ME numeric(15, 7),
        	@CosTot_ME numeric(15, 7),
        	@CA11 nvarchar(300),
        	@CA12 nvarchar(300),
        	@CA13 nvarchar(300),
        	@CA14 nvarchar(300),
        	@CA15 nvarchar(300),
        	@CA16 nvarchar(4000),
        	@CA17 nvarchar(4000),
        	@CA18 nvarchar(4000),
        	@CA19 nvarchar(4000),
        	@CA20 nvarchar(4000),
        	@CA21 nvarchar(4000),
        	@CA22 nvarchar(4000),
        	@CA23 nvarchar(4000),
        	@CA24 nvarchar(4000),
        	@CA25 nvarchar(4000),
        @Cd_Clt char(10)
	as
        
	Set @Cd_OF = dbo.Cd_OF(@RucE)	
        	if exists (select * from ordfabricacion where RucE=@RucE and Cd_OF=@Cd_OF and NroOF=@NroOF)
	Set @msj = 'Ya existe numero de orden de fabricacion'

	else
	begin 
	insert into ordfabricacion(RucE,Cd_OF,NroOF,FecE,FecEntR,Cd_Area,Cd_Prod,Cd_Alm,ID_UMP,Asunto,Obs,Lote,CosTot,Cant,
		CU,Cd_Mda,CamMda,FecReg,FecMdf,UsuCrea,UsuModf,Cd_CC,Cd_SC,Cd_SS,Id_EstOF,TipAut,IB_Aut,AutorizadoPor,
        	CA01,CA02,CA03,CA04,CA05,CA06,CA07,CA08,CA09,CA10,CdOF_Base,ID_Fmla,CU_ME,CosTot_ME,CA11,CA12,CA13,CA14,CA15,
        	CA16,CA17,CA18,CA19,CA20,CA21,CA22,CA23,CA24,CA25, Cd_Clt)
	values(@RucE,@Cd_OF,@NroOF,@FecE,@FecEntR,@Cd_Area,@Cd_Prod,@Cd_Alm,@ID_UMP,@Asunto,@Obs,@Lote,@CosTot,@Cant,
		@CU,@Cd_Mda,@CamMda,getdate(),null,@UsuCrea,null,@Cd_CC,@Cd_SC,@Cd_SS,@Id_EstOF,@TipAut,@IB_Aut,@AutorizadoPor,
        	@CA01,@CA02,@CA03,@CA04,@CA05,@CA06,@CA07,@CA08,@CA09,@CA10,@CdOF_Base,@ID_Fmla,@CU_ME,@CosTot_ME,@CA11,@CA12,
        	@CA13,@CA14,@CA15,@CA16,@CA17,@CA18,@CA19,@CA20,@CA21,@CA22,@CA23,@CA24,@CA25, @Cd_Clt)
	if @@rowcount <= 0
		Set @msj = 'Error al registrar orden de fabricacion'
	end
	--- Leyenda ---
	--- FL: 27/02/2011 <creacion del sp>








GO
