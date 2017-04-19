SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE procedure [user321].[Com_ScxProvCons_xSolCom_2]
@RucE nvarchar(11),
@Cd_SCo char(10),
@msj nvarchar(100) output
as
if not exists (select * from SolicitudCom where RucE = @Ruce and Cd_Sco = @Cd_Sco)
	set @msj = 'No existe solicitud de compra'
else
begin
	------ 1
	select  	'',sp.Cd_SCoEnv, sp.Cd_Prv,
		--b.NCorto, b.Cd_TDI, NDoc, 
		(isnull(p.RSocial,'')+ isnull(p.ApPat,'') +' '+ isnull(p.ApMat,'') + ' ' + isnull(p.Nom,'')) as 'Nombre_Prv'
		,p.correo as 'Correo_Prv',sp.Cd_Sco,sp.RucE,sp.IB_Env, sp.FecEnv, 
		sp.IB_Impr, sp.FecImpr, sp.Prv_FecEnt, sp.Prv_Obs, 
		--'' as 'Cd_Prv_C', '' as 'Nombre_Contacto',
		'' as 'Direc_C', b.Cd_TDI
		--,'' as 'Correo_C'
	from SCxProv sp
	inner join Proveedor2 p on p.Cd_Prv = sp.Cd_Prv and p.RucE = @RucE
	join TipDocIdn b on p.Cd_TDI = b.Cd_TDI 
	where sp.Cd_Sco = @Cd_SCo and sp.RucE = @RucE
	------- 2
	select  	'',sp.Cd_SCoEnv,/*c.RucE,sp.Cd_SCoEnv,sp.Cd_prv,*/
				--b.NCorto, b.Cd_TDI,''as NDoc,
		--'' as 'Nombre_Prv',
		--p.correo as 'Correo_Prv',
		c.Cd_prv as 'Cd_Prv_C',(isnull(c.Nom,'') + ' ' +isnull(c.ApPat,'') +' '+ isnull(c.ApMat,'')) as 'Nombre_Contacto',
		--c.Direc as 'Direc_C',--c.Telf as 'Telf_C',
		c.Correo as 'Correo_C',sp.Cd_Sco,sp.RucE,sp.IB_Env, sp.FecEnv, 
		sp.IB_Impr, sp.FecImpr, sp.Prv_FecEnt, sp.Prv_Obs,
		--c.Cargo as 'Cargo_C'--,c.IB_Prin,c.estado
		c.Direc as 'Direc_C', b.Cd_TDI
	from SCxProv sp
	inner join Proveedor2 p on p.RucE = @RucE and p.Cd_Prv = sp.Cd_Prv
	inner join Contacto c on c.RucE = @RucE and c.Cd_Prv = p.Cd_Prv
	join TipDocIdn b on p.Cd_TDI = b.Cd_TDI 
	where sp.Cd_Sco = @Cd_SCo and sp.RucE = @RucE
	
end



--exec user321.Com_ScxProvCons_xSolCom_2 '11111111111','SR00000197',null

--Leyenda: 09:11:2012

GO
