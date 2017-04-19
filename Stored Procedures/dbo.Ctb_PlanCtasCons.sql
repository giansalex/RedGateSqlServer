SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Ctb_PlanCtasCons]
@RucE nvarchar(11),
@Ejer varchar(4),
@TipCons int,
@msj varchar(100) output
as
/*if not exists (select top 1 * from PlanCtas where RucE=@RucE)
	set @msj = 'No se encontro Plan de Cuenta'
else	*/
begin
	if(@TipCons=0)
	begin	
		select
			RucE,NroCta,NomCta,Nivel,
			IB_Aux,	IB_CC,IB_DifC,IB_GCB,IB_Psp,IB_CtasXCbr,IB_CtasXPag,
			IB_MdVta,IB_MdCom,IB_MdCtb,IB_MdTsr,IB_MdPrs,IB_MdInv,
			Cd_Blc,Cd_EGPF,Cd_EGPN,
			IB_CtaD,IC_ASM,IC_ACV,Estado	
		from PlanCtas where RucE=@RucE and Ejer=@Ejer
	end
	else if(@TipCons=1)
		select str(NroCta,6,0)+ ' | ' + NomCta as CodNom,NroCta,NomCta  from PlanCtas where RucE=@RucE and Ejer=@Ejer
	else if(@TipCons=3)
		select NroCta,NroCta,NomCta from PlanCtas where RucE=@RucE /*and  len(NroCta)>=9 */ and Estado=1 and Ejer=@Ejer
end
print @msj 



/*
     0: General: select * from Tabla
     1: ComboBox: select CodNom, Cd_Entidad from Tabla where Estado=1
     2: Activos: select * from Tabla where Estado=1
     3: Ayuda: select Cd_Ent,NroDoc,Nombre from Tabla
*/

--PV: Jue 29/01/09
--PV: Jue 02/02/09
GO
