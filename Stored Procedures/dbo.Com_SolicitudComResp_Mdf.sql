SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Com_SolicitudComResp_Mdf]

@RucE nvarchar(11),
@Cd_SCo char(10),
@Cd_SCoEnv int,
@Cd_Prov char(7),
@Item int,
@IB_Acp bit,
@msj varchar(100) output

AS

update SCxProvDet Set
	IB_Acp=@IB_Acp
Where 
	RucE=@RucE
	and Cd_SCoEnv=@Cd_SCoEnv
	and Cd_Prov=@Cd_Prov
	and Item=@Item
	
	--*****************************
	-- Manejo de estados
	Declare @cant_acep int
	Set @cant_acep=''
	
	Select 
		@cant_acep=Sum(Convert(int,d.IB_Acp))
	From SCxProvDet d
		Left Join SCxProv s On s.RucE=d.RucE and s.Cd_SCoEnv=d.Cd_SCoEnv
	Where
		s.RucE=@RucE
		and s.Cd_SCo=@Cd_SCo
		and s.Cd_Prv=@Cd_Prov
		
	
	if(@cant_acep>0)
		Update SCxProv Set Id_EstSCResp='02' Where RucE=@RucE and Cd_SCo=@Cd_SCo and Cd_Prv=@Cd_Prov 
	else
		Update SCxProv Set Id_EstSCResp='03' Where RucE=@RucE and Cd_SCo=@Cd_SCo and Cd_Prv=@Cd_Prov
	--*****************************
	
	
	 
-- Leyenda --
-- DI <07/06/2012 : Creacion del SP>
	
GO
