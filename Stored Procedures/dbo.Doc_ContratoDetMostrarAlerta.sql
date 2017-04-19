SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[Doc_ContratoDetMostrarAlerta]
@RucE nvarchar(11),
@msj varchar(100) output
as

if not exists (select FecDef from ContratoDet where RucE=@RucE group by FecDef
having (DATEDIFF(DAY,GETDATE(),FecDef) BETWEEN 0 AND 5))
begin
	set @msj = 'No hay Alertas Pendientes'
end
else
begin
select det.Cd_Ctt
,case
	when isnull(con.Cd_Clt,'')='' then 
	case 
	when isnull(con.Cd_Prv,'')='' then isnull(ven.RSocial,isnull(ven.ApPat,'')+' '+isnull(ven.ApMat,'')+' '+isnull(ven.Nom,'')) 
	else isnull(pro.RSocial,isnull(pro.ApPat,'')+' '+isnull(pro.ApMat,'')+' '+isnull(pro.Nom,''))	
	end
	else isnull(cli.RSocial,isnull(cli.ApPat,'')+' '+isnull(cli.ApMat,'')+' '+isnull(cli.Nom,''))
	end as Auxiliar 
,case
	when isnull(con.Cd_Clt,'')='' then 
	case 
	when isnull(con.Cd_Prv,'')='' then isnull(ven.NDoc,'') 
	else isnull(pro.NDoc,'')
	end
	else isnull(cli.NDoc,'')
	end as NumDoc 
,convert(varchar,FecIni,103)FecIni
,convert(varchar,FecFin,103)FecFin,ValorDef
,convert(varchar,FecDef,103)FecDef,TotalDef
,DATEDIFF(DAY,GETDATE(),FecDef) as DiasRestantes 
from ContratoDet as det join Contrato as con 
on (con.Cd_Ctt = det.Cd_Ctt and con.RucE = det.RucE) 
left join Cliente2 as cli on (cli.Cd_Clt=con.Cd_Clt and cli.RucE=con.RucE)
left join Proveedor2 as pro on (pro.Cd_Prv=con.Cd_Prv and pro.RucE=con.RucE)
left join Vendedor2 as ven on (ven.Cd_Vdr=con.Cd_Vdr and ven.RucE=con.RucE) 
where con.RucE = @RucE 
group by det.Cd_Ctt
,con.Cd_Clt,cli.RSocial,cli.ApPat,cli.ApMat,cli.Nom,cli.NDoc
,con.Cd_Prv,pro.RSocial,pro.ApPat,pro.ApMat,pro.Nom,pro.NDoc
,con.Cd_Vdr,ven.RSocial,ven.ApPat,ven.ApMat,ven.Nom,ven.NDoc
,FecIni,FecFin,ValorDef,FecDef,TotalDef
having (DATEDIFF(DAY,GETDATE(),FecDef) BETWEEN 0 AND 5)
end
GO
