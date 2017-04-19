SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Lf_LiqFondoModf]
@RucE nvarchar(11),
@Cd_Liq char(10),
@RegCtb nvarchar (15),
@FechaAper datetime,
@FechaCierre datetime,
@UsuAper varchar (50),
@FecAper datetime,
@UsuCierre varchar (50),
@FecCierre datetime,
@Cd_Area nvarchar(6),
@Cd_CC nvarchar (8),
@Cd_SC nvarchar (8),
@Cd_SS nvarchar (8),
@Cd_MIS char(3),
@Cd_Mda nvarchar (2),
@CamMda numeric (6,3),
@MtoAnt numeric (18,3),
@MtoAsig numeric (18,3),
@MtoAper numeric (18,3),
@MtoCierre numeric (18,3),
@MtoAnt_ME numeric (18,3),
@MtoAsig_ME numeric (18,3),
@MtoAper_ME numeric (18,3),
@MtoCierre_ME numeric (18,3),
@CA01 varchar (100),
@CA02 varchar (100),
@CA03 varchar (100),
@CA04 varchar (100),
@CA05 varchar (100),
@CA06 varchar (100),
@CA07 varchar (100),
@CA08 varchar (100),
@CA09 varchar (100),
@CA10 varchar (100),
@msj varchar(100) output
as
if not exists (select * from Liquidacion where RucE=@RucE and Cd_Liq=@Cd_Liq)
	set @msj = 'Liquidacion no existe'
else

update Liquidacion set RegCtb = @RegCtb,FechaAper = @FechaAper, FechaCierre = @FechaCierre,UsuAper = @UsuAper,
						FecAper = @FecAper,UsuCierre=@UsuCierre,Cd_Area=@Cd_Area,Cd_CC =@Cd_CC,Cd_SC = @Cd_SC,Cd_MIS=@Cd_MIS,Cd_Mda=@Cd_Mda,CamMda=@CamMda,MtoAnt=@MtoAnt,
						MtoAsig =@MtoAsig,	MtoAper=@MtoAper,MtoCierre=@MtoCierre,MtoAnt_ME=@MtoAnt_ME,MtoAsig_ME=@MtoAsig_ME,MtoAper_ME=@MtoAper_ME,
						MtoCierre_ME =@MtoCierre_ME,CA01=@CA01,CA02=@CA02,CA03=@CA03,CA04 =@CA04,CA05=@CA05,CA06=@CA06,CA07=@CA07,CA08=@CA08,CA09=@CA09,CA10 =@CA10
					where RucE = @RucE and Cd_Liq = @Cd_Liq
print @msj

--Leyenda

--BG : 28/02/2013 <se creo el SP modificar>
--bg: 01/03/2013 <se agrego 2 campos Cd_Mda y CamMda>
--bg: 08/03/2013 <se agrego el where del update T-T>
GO
