SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Doc_ContratoPendienteCons]
@RucE char(11),
@NomUsu nvarchar(20),
@msj varchar(100) output
AS
BEGIN
	SET NOCOUNT ON;
	if not exists (select * from areaxusuario where RucE=@RucE and NomUsu=@NomUsu)
		set @msj='Usuario no Autorizado'
	else
		begin
			if not exists (select FecFin from Contrato where RucE=@RucE group by FecFin
			having (datediff(d,getdate(),Fecfin)<6 and datediff(d,getdate(),Fecfin)>-1))
			begin
				set @msj = 'No hay Alertas Pendientes'
			end
			else
				begin
					select con.RucE
,case
	when isnull(con.Cd_Clt,'')='' then 
	case 
	when isnull(con.Cd_Prv,'')='' then isnull(vdr.RSocial,isnull(vdr.ApPat,'')+' '+isnull(vdr.ApMat,'')+' '+isnull(vdr.Nom,'')) 
	else isnull(prv.RSocial,isnull(prv.ApPat,'')+' '+isnull(prv.ApMat,'')+' '+isnull(prv.Nom,''))	
	end
	else isnull(clt.RSocial,isnull(clt.ApPat,'')+' '+isnull(clt.ApMat,'')+' '+isnull(clt.Nom,''))
	end as Auxiliar 
,case
	when isnull(con.Cd_Clt,'')='' then 
	case 
	when isnull(con.Cd_Prv,'')='' then isnull(vdr.NDoc,'') 
	else isnull(prv.NDoc,'')
	end
	else isnull(clt.NDoc,'')
	end as NumDoc 
,con.Cd_Ctt,con.FecIni,con.FecFin,con.Descrip,con.Obs,con.FecReg,con.FecMdf,con.UsuCrea,con.UsuMdf,con.Cd_CC,con.Cd_SC,con.Cd_SS,cc.Descrip as Distrito, sc.Descrip as Edificio, ss.Descrip as Departamento
			from contrato con left join Cliente2 clt on (con.Cd_Clt = clt.Cd_Clt and con.RucE = clt.RucE)
							  left join Proveedor2 prv on (con.Cd_Prv = prv.Cd_Prv and con.RucE = prv.RucE)
							  left join Vendedor2 vdr on (con.Cd_Vdr = vdr.Cd_Vdr and con.RucE = vdr.RucE)
							  left join CCostos cc on (con.Cd_CC = cc.Cd_CC and con.RucE = cc.RucE)
							  left join CCSub sc on (con.Cd_SC = sc.Cd_SC and con.Cd_CC = sc.Cd_CC and con.RucE = sc.RucE)
							  left join CCSubSub ss on (con.Cd_SS = ss.Cd_SS and con.Cd_SC = ss.Cd_SC and con.Cd_CC = ss.Cd_CC and con.RucE = ss.RucE)
			where con.RucE=@RucE 
			and datediff(d,getdate(),con.fecfin)<6 and datediff(d,getdate(),con.fecfin)>-1
		end
	END
END
GO
