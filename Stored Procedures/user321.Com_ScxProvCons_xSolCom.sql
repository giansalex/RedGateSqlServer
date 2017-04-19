SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE procedure [user321].[Com_ScxProvCons_xSolCom]
@RucE nvarchar(11),
@Cd_SCo char(10),
@msj nvarchar(100) output
as
if not exists (select * from SolicitudCom where RucE = @Ruce and Cd_Sco = @Cd_Sco)
	set @msj = 'No existe solicitud de compra'
else
begin
	select  	sp.RucE, sp.Cd_SCoEnv, sp.Cd_Sco, sp.Cd_Prv, sp.IB_Env, sp.FecEnv, 
		sp.IB_Impr, sp.FecImpr, sp.Prv_FecEnt, sp.Prv_Obs, b.NCorto, b.Cd_TDI, NDoc, 
		(isnull(p.RSocial,'')+ isnull(p.ApPat,'') +' '+ isnull(p.ApMat,'') + ' ' + isnull(p.Nom,'')) as 'Nombre_Prv'
		, p.Correo , Cd_FPC

	from SCxProv sp
	left join Proveedor2 p on p.Cd_Prv = sp.Cd_Prv and p.RucE = @RucE
	join TipDocIdn b on p.Cd_TDI = b.Cd_TDI 

	where sp.Cd_Sco = @Cd_SCo and sp.RucE = @RucE
end

-- exec user321.Com_ScxProvCons_xSolCom '11111111111','SC00000292',null
-- select * from SolicitudCom where RucE='11111111111'

--Leyenda
--NO se
GO
