SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create PROC [dbo].[Prd_OrdFabricacionCrea_1]
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
		@CosTot numeric(13,2),
		@Cant numeric(13,2),
		@CU numeric(13,2),
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
        	@CU_ME numeric(13,2),
        	@CosTot_ME numeric(13,2)
        	
	as
        
	Set @Cd_OF = dbo.Cd_OF(@RucE)	
        	if exists (select * from ordfabricacion where RucE=@RucE and Cd_OF=@Cd_OF and NroOF=@NroOF)
	Set @msj = 'Ya existe numero de orden de fabricacion'

	else
	begin 
	insert into ordfabricacion(RucE,Cd_OF,NroOF,FecE,FecEntR,Cd_Area,Cd_Prod,Cd_Alm,ID_UMP,Asunto,Obs,Lote,CosTot,Cant,
		CU,Cd_Mda,CamMda,FecReg,FecMdf,UsuCrea,UsuModf,Cd_CC,Cd_SC,Cd_SS,Id_EstOF,TipAut,IB_Aut,AutorizadoPor,
        	CA01,CA02,CA03,CA04,CA05,CA06,CA07,CA08,CA09,CA10,CdOF_Base,ID_Fmla,CU_ME,CosTot_ME)
	values(@RucE,@Cd_OF,@NroOF,@FecE,@FecEntR,@Cd_Area,@Cd_Prod,@Cd_Alm,@ID_UMP,@Asunto,@Obs,@Lote,@CosTot,@Cant,
		@CU,@Cd_Mda,@CamMda,getdate(),null,@UsuCrea,null,@Cd_CC,@Cd_SC,@Cd_SS,@Id_EstOF,@TipAut,@IB_Aut,@AutorizadoPor,
        	@CA01,@CA02,@CA03,@CA04,@CA05,@CA06,@CA07,@CA08,@CA09,@CA10,@CdOF_Base,@ID_Fmla,@CU_ME,@CosTot_ME)
	if @@rowcount <= 0
		Set @msj = 'Error al registrar orden de fabricacion'
	end
	--- Leyenda ---
	--- FL: 27/02/2011 <creacion del sp>








GO
