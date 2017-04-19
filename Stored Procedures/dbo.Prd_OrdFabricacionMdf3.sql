SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create PROC [dbo].[Prd_OrdFabricacionMdf3]
@RucE nvarchar(11),
@Cd_OF char(10),
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
@FecMdf smalldatetime,
@UsuModf nvarchar(10),
@Cd_CC nvarchar(8),
@Cd_SC nvarchar(8),
@Cd_SS nvarchar(8),
@Id_EstOF char(2),
@TipAut int,
--@IB_Aut bit,
--@AutorizadoPor varchar(200),
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
@CU_ME numeric(13,2),
@CosTot_ME numeric(13,2),
@msj varchar(100) output
        	
as
if not exists (select * from ordfabricacion where RucE=@RucE and Cd_OF=@Cd_OF and NroOF=@NroOF)
	Set @msj = 'No existe numero de orden de fabricacion'
else
begin 
	update ordfabricacion set
	FecE=@FecE,FecEntR=@FecEntR,Cd_Area=@Cd_Area,Cd_Prod=@Cd_Prod,Cd_Alm=@Cd_Alm,ID_UMP=@ID_UMP,Asunto=@Asunto,Obs=@Obs,
	Lote=@Lote,CosTot=@CosTot,CosTot_ME=@CosTot_ME,Cant=@Cant,CU=@CU,CU_ME=@CU_ME,Cd_Mda=@Cd_Mda,FecMdf=@FecMdf,UsuModf=@UsuModf,Cd_CC=@Cd_CC,Cd_SC=@Cd_SC,
	Cd_SS=@Cd_SS,Id_EstOF=@Id_EstOF,TipAut=@TipAut,CA01=@CA01,CA02=@CA02,CA03=@CA03,
	CA04=@CA04,CA05=@CA05,CA06=@CA06,CA07=@CA07,CA08=@CA08,CA09=@CA09,CA10=@CA10,ID_Fmla=@ID_Fmla
	where RucE=@RucE and Cd_OF=@Cd_OF and NroOF=@NroOF
	if @@rowcount <= 0
		Set @msj = 'Error al modificar orden de fabricacion'
end
-- Leyenda ---
-- FL: 04/03/2011 <creacion del sp>
-- MM: 29/03/2011 <modificacion del sp : se quito los campos IB_Aut y AutorizadoPor (esos campos los maneja autorizaciones)>
GO
