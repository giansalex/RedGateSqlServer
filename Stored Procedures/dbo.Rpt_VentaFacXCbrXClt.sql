SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--declare 
--@RucE nvarchar(11),
--@Ejer varchar(4),
--@NDocCli char(11),
--@FecVen datetime,
--@Cd_Mda char(2),
--@msj nvarchar(100)

--set @RucE = '11111111111'
--set @Ejer = '2011'
--set @FecVen = '31/10/2011'
--set @Cd_Mda = '01'
--set @NDocCli = '20101314724'

CREATE procedure [dbo].[Rpt_VentaFacXCbrXClt]
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
)
set @msj = 'No existen facturas pendientes para este cliente'

else
begin
select NDocAux, Max(NomAux), Cd_Td, count(Cd_td) as CantFac , sum(Saldo) as TotalDeuda from 
(
Select 
      isnull(c.NDoc,isnull(r.NDoc,'-- Sin Documento --')) As NDocAux,
       Case When isnull(v.Cd_Clt,'')='' and isnull(v.Cd_Prv,'')='' Then '-- Sin Auxiliar --' 
       Else Case When isnull(v.Cd_Clt,'')<>'' Then isnull(c.RSocial,isnull(c.ApPat,'')+' '+isnull(c.ApMat,'')+' '+isnull(c.Nom,'')) 
       Else isnull(r.RSocial,isnull(r.ApPat,'')+' '+isnull(r.ApMat,'')+' '+isnull(r.Nom,'')) 
       End End As NomAux,
       isnull(v.Cd_TD,'') As Cd_TD,
       Sum(Case When @Cd_Mda='01' Then v.MtoD Else v.MtoD_ME End) - Sum(Case When @Cd_Mda='01' Then v.MtoH Else v.MtoH_ME End) As Saldo

From 
       Voucher v
       Inner Join PlanCtas p On p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta and isnull(p.IB_CtasXCbr,0)=1
       left join Cliente2 as c on c.RucE=v.RucE and c.Cd_Clt=v.Cd_Clt
       left join Proveedor2 as r on r.RucE=v.RucE and r.Cd_Prv = v.Cd_Prv
Where v.RucE=@RucE and v.Ejer=@Ejer and v.FecMov < @FecVen
       and isnull(v.Ib_Anulado,0)=0


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
)  as t
where Cd_td=@Cd_TD and NDocAux = @NDocCli
GROUP BY NDocAux, Cd_td
end
GO
