SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [user321].[Com_SolicitudComConsUn_paOC]

@RucE nvarchar(11),
@Cd_SCo char(10),
@msj varchar(100) output

as 
if not exists (select * from SolicitudCom where RucE=@RucE and Cd_Sco=@Cd_SCo)
begin
	Set @msj = 'No existe Solicitud de Compra.'
	print @msj
end
else
begin
/*
	select	sc.Cd_SCo, sc.NroSC,sc.Cd_FPC, sc.Cd_Area,sc.Cd_CC,sc.Cd_SC, sc.Cd_SS          
	from SolicitudCom sc
	where sc.RucE=@RucE and sc.Cd_SCo=@Cd_SCo
*/
	select	sc.Cd_SCo, sc.NroSC,/*sc.Cd_FPC,*/ 
	
			case (select top 1 IB_Acp from SCxProvdet where RucE = @RucE and 
			Cd_SCoEnv = (select top 1 Cd_SCoEnv from SCxProv where RucE = @RucE and Cd_SCo = @Cd_SCo)) 
			when 1 then isnull(sp.Cd_FPC,0) else isnull(sc.Cd_FPC,1) end as Cd_FPC,

	sc.Cd_Area,sc.Cd_CC,sc.Cd_SC, sc.Cd_SS, sp.Cd_Prv, pv.Cd_TDI, 
		isnull(pv.rsocial, pv.appat+' '+pv.apmat+', '+pv.nom) DescPrv, isnull(pv.NDoc,'-') as NDoc, sc.Asunto, sc.Obs, FecEntR,
		sc.CA01, sc.CA02,sc.CA03,sc.CA04,sc.CA05
	from SolicitudCom sc 
	left join SCxProv sp on sp.RucE = sc.RucE and sp.Cd_SCo = sc.Cd_Sco 
	left join Proveedor2 pv on pv.Cd_Prv = sp.Cd_Prv and pv.RucE = @RucE
	where sc.RucE=@RucE and sc.Cd_SCo=@Cd_SCo 

end
-- Leyenda --
-- JU   : 2010-08-04 : <Creacion del procedimiento almacenado>
-- MM:  2010-08-04 : <Creacion del procedimiento almacenado>
-- exec user321.Com_SolicitudComConsUn_paOC '11111111111','SC00000295',null
-- exec user321.Com_SolicitudComConsUn_paOC '07120000000','SC00000003',null
/*
select top 1 IB_Acp from SCxProvdet where RucE = '11111111111' and 
Cd_SCoEnv = (select Cd_SCoEnv from SCxProv where RucE = '11111111111' and Cd_SCo = 'SC00000295')

select * from SCxProv where RucE = '11111111111' and Cd_SCo = 'SC00000295'
select Cd_SCoEnv from SCxProv where RucE = '07120000000' and Cd_SCo = 'SC00000003'

select * from SolicitudCom where RucE = '11111111111' and Cd_SCo = 'SC00000298'
select * from EstadoSC

select * from SolicitudCom where RucE = '07120000000' and Cd_SCo = 'SC00000003'
select * from EstadoSC

*/
GO
