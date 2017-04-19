SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_TraConsUn]
@RucE nvarchar(11),
@Cd_Tra char(7),
@Cd_TD nvarchar(2),
@msj varchar(100) output
as
begin
--if(@Cd_TD='31')
	--begin
		select Cd_TDI,NDoc,Nom,ApPat,ApMat,RSocial from transportista where RucE=@RucE and Cd_tra=@Cd_tra
	--end
	--else if (@Cd_TD='09')
	--begin
		--select Cd_TDI,NDoc,Nom,ApPat,ApMat,RSocial from transportista where RucE=@RucE and Cd_tra=@Cd_tra
	--end
	--else if (@Cd_TD='01')
	--begin
		--select Cd_TDI,NDoc,Nom,ApPat,ApMat,RSocial from transportista where RucE=@RucE and Cd_tra=@Cd_tra
	--end
end
print @msj
--Leyenda--
--FL: 08/09/2010 : <Creacion del procedimiento almacenado>



GO
