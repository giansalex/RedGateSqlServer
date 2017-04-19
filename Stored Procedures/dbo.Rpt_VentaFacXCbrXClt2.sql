SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [dbo].[Rpt_VentaFacXCbrXClt2]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@NDocCli nchar(11),
@FecVen datetime,
@Cd_Mda nchar(2),
@Cd_TD nchar(2),
@msj nvarchar(100) output
as
if not exists
(
select c.NDoc from voucher v
inner join Cliente2 c on v.RucE = c.RucE and v.Cd_Clt = c.Cd_Clt
where 
v.RucE = @RucE and v.Ejer = @Ejer and c.NDoc = @NDocCli 
union
select c.NDoc from Venta v
inner join Cliente2 c on v.RucE = c.RucE and v.Cd_Clt = c.Cd_Clt
where 
v.RucE = @RucE and v.Eje = @Ejer and c.NDoc = @NDocCli 
)
begin
set @msj = 'No existe el cliente'
print @Msj
end

else
begin
if not exists
(
		select NDocAux,NomAux,MAX(Cd_TD) as Cd_TD,Count(Cd_TD) as CantDoc,Sum(Saldo) as TotalDeuda from
		(
		/*****Solo ventas***/
		select 
		clt.NDoc as NDocAux,
		case when isnull(clt.RSocial,'')<>'' then clt.Rsocial else clt.ApPat + ' ' + clt.ApMat + ' '+clt.Nom end as NomAux,
		Cd_TD,
		Total as Saldo 
		from Venta vt
		inner join Cliente2 clt on vt.RucE = clt.RucE and vt.Cd_Clt = clt.Cd_Clt
		where vt.RucE = @RucE and vt.Eje = @Ejer and vt.FecMov /*between @FecDesde and*/<= @FecVen and vt.Cd_TD = @Cd_TD and clt.NDoc = @NDocCli
		and RegCtb not in
		(
			select RegCtb from Voucher v 
			inner join Cliente2 clt on v.RucE = clt.RucE and v.Cd_Clt = clt.Cd_Clt 
			where v.RucE = @RucE and v.Ejer = @Ejer and v.Cd_TD = @Cd_TD and clt.NDoc = @NDocCli
		)
		/*****Fin de ventas*****/
		union all
		/******Solo Voucher*********/
		Select 
			  isnull(c.NDoc,isnull(r.NDoc,'-- Sin Documento --')) As NDocAux,
			   Case When isnull(v.Cd_Clt,'')='' and isnull(v.Cd_Prv,'')='' Then '-- Sin Auxiliar --' 
			   Else Case When isnull(v.Cd_Clt,'')<>'' Then isnull(c.RSocial,isnull(c.ApPat,'')+' '+isnull(c.ApMat,'')+' '+isnull(c.Nom,'')) 
			   Else isnull(r.RSocial,isnull(r.ApPat,'')+' '+isnull(r.ApMat,'')+' '+isnull(r.Nom,'')) 
			   End End As NomAux,
			   isnull(v.Cd_TD,'') As Cd_TD,
			   Sum(Case When @Cd_Mda='01' Then v.MtoD Else v.MtoD_ME End) - Sum(Case When @Cd_Mda='01' Then v.MtoH Else v.MtoH_ME End) As TotalDeuda

		From 
			   Voucher v
			   Inner Join PlanCtas p On p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta and isnull(p.IB_CtasXCbr,0)=1
			   left join Cliente2 as c on c.RucE=v.RucE and c.Cd_Clt=v.Cd_Clt
			   left join Proveedor2 as r on r.RucE=v.RucE and r.Cd_Prv = v.Cd_Prv
		Where v.RucE=@RucE and v.Ejer=@Ejer and v.FecMov /*between @FecDesde and*/<= @FecVen
			   and isnull(v.Ib_Anulado,0)=0 and c.NDoc=@NDocCli
		Group by 
			   v.NroCta,
			   isnull(c.NDoc,isnull(r.NDoc,'-- Sin Documento --')),
			   Case When isnull(v.Cd_Clt,'')='' and isnull(v.Cd_Prv,'')='' Then '-- Sin Auxiliar --' 
			   Else Case When isnull(v.Cd_Clt,'')<>'' Then isnull(c.RSocial,isnull(c.ApPat,'')+' '+isnull(c.ApMat,'')+' '+isnull(c.Nom,'')) 
			   Else isnull(r.RSocial,isnull(r.ApPat,'')+' '+isnull(r.ApMat,'')+' '+isnull(r.Nom,'')) 
			   End End,
			   isnull(v.Cd_TD,''),
			   isnull(v.NroSre,''),
			   isnull(v.NroDoc,'')
		Having
			   Sum(Case When @Cd_Mda='01' Then v.MtoD Else v.MtoD_ME End) - Sum(Case When @Cd_Mda='01' Then v.MtoH Else v.MtoH_ME End)<> 0
		/**********fin Voucher**************/
		) as t
		group by NomAux,NDocAux
)
begin
		declare @NomCli nvarchar(200) set @NomCli = ''
		select @NomCli = (case when isnull(RSocial,'')<>'' then RSocial else ApPat+' '+ApMat+' '+Nom end) from Cliente2 where RucE = @RucE and NDoc = @NDocCli
		select @NDocCli as NDocAux, @NomCli as NomAux,@Cd_TD as Cd_TD, 0.00 as TotalDeuda
end
else
begin
		select NDocAux,NomAux,MAX(Cd_TD) as Cd_TD,Count(Cd_TD) as CantDoc,Sum(Saldo) as TotalDeuda from
		(
		/*****Solo ventas***/
		select 
		clt.NDoc as NDocAux,
		case when isnull(clt.RSocial,'')<>'' then clt.Rsocial else clt.ApPat + ' ' + clt.ApMat + ' '+clt.Nom end as NomAux,
		Cd_TD,
		Total as Saldo 
		from Venta vt
		inner join Cliente2 clt on vt.RucE = clt.RucE and vt.Cd_Clt = clt.Cd_Clt
		where vt.RucE = @RucE and vt.Eje = @Ejer and vt.FecMov /*between @FecDesde and*/<= @FecVen and vt.Cd_TD = @Cd_TD and clt.NDoc = @NDocCli
		and RegCtb not in
		(
			select RegCtb from Voucher v 
			inner join Cliente2 clt on v.RucE = clt.RucE and v.Cd_Clt = clt.Cd_Clt 
			where v.RucE = @RucE and v.Ejer = @Ejer and v.Cd_TD = @Cd_TD and clt.NDoc = @NDocCli
		)
		/*****Fin de ventas*****/
		union all
		/******Solo Voucher*********/
		Select 
			  isnull(c.NDoc,isnull(r.NDoc,'-- Sin Documento --')) As NDocAux,
			   Case When isnull(v.Cd_Clt,'')='' and isnull(v.Cd_Prv,'')='' Then '-- Sin Auxiliar --' 
			   Else Case When isnull(v.Cd_Clt,'')<>'' Then isnull(c.RSocial,isnull(c.ApPat,'')+' '+isnull(c.ApMat,'')+' '+isnull(c.Nom,'')) 
			   Else isnull(r.RSocial,isnull(r.ApPat,'')+' '+isnull(r.ApMat,'')+' '+isnull(r.Nom,'')) 
			   End End As NomAux,
			   isnull(v.Cd_TD,'') As Cd_TD,
			   Sum(Case When @Cd_Mda='01' Then v.MtoD Else v.MtoD_ME End) - Sum(Case When @Cd_Mda='01' Then v.MtoH Else v.MtoH_ME End) As TotalDeuda

		From 
			   Voucher v
			   Inner Join PlanCtas p On p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta and isnull(p.IB_CtasXCbr,0)=1
			   left join Cliente2 as c on c.RucE=v.RucE and c.Cd_Clt=v.Cd_Clt
			   left join Proveedor2 as r on r.RucE=v.RucE and r.Cd_Prv = v.Cd_Prv
		Where v.RucE=@RucE and v.Ejer=@Ejer and v.FecMov /*between @FecDesde and*/<= @FecVen
			   and isnull(v.Ib_Anulado,0)=0 and c.NDoc=@NDocCli
		Group by 
			   v.NroCta,
			   isnull(c.NDoc,isnull(r.NDoc,'-- Sin Documento --')),
			   Case When isnull(v.Cd_Clt,'')='' and isnull(v.Cd_Prv,'')='' Then '-- Sin Auxiliar --' 
			   Else Case When isnull(v.Cd_Clt,'')<>'' Then isnull(c.RSocial,isnull(c.ApPat,'')+' '+isnull(c.ApMat,'')+' '+isnull(c.Nom,'')) 
			   Else isnull(r.RSocial,isnull(r.ApPat,'')+' '+isnull(r.ApMat,'')+' '+isnull(r.Nom,'')) 
			   End End,
			   isnull(v.Cd_TD,''),
			   isnull(v.NroSre,''),
			   isnull(v.NroDoc,'')
		Having
			   Sum(Case When @Cd_Mda='01' Then v.MtoD Else v.MtoD_ME End) - Sum(Case When @Cd_Mda='01' Then v.MtoH Else v.MtoH_ME End)<> 0
		/**********fin Voucher**************/
		) as t
		group by NomAux,NDocAux
end
end
/****Creado****/

--<JA: 11/04/2012>
--Prueba exec 

GO
