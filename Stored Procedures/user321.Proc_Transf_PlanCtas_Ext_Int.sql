SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Proc_Transf_PlanCtas_Ext_Int]
@RucE nvarchar(11),
@RucEBase nvarchar(11),
@Ejer varchar(4),
@IpServer varchar(100),
@UsuConeccion varchar(30),
@PasswordConeccion varchar(30)
as

declare @Consulta varchar(4000)

set @Consulta='
delete PlanCtas where RucE='''+@RucE+''' and Ejer='''+@Ejer+'''

insert into PlanCtas(RucE,Ejer,NroCta,NomCta,Nivel,IB_Aux,IB_CC,IB_DifC,IC_ACV,IC_ASM,IB_GCB,IB_Psp,IB_CtaD,IB_MdVta,IB_MdCom,IB_MdCtb,IB_MdTsr,IB_MdPrs,IB_MdInv,Cd_Blc,
					 Cd_EGPN,Cd_EGPF,IB_CtasXCbr,IB_CtasXPag,Estado,Cd_Mda,IC_IEF,IC_IEN,NroCtaH1,NomCtaH1,NroCtaH2,NomCtaH2,IB_PFC,IB_NDoc,IB_Prod,IB_Imp,IB_Dtr)
	SELECT  
		*
	from 
	OPENROWSET(''SQLOLEDB'','''+@IpServer+''';'''+@UsuConeccion+''';'''+@PasswordConeccion+''',
	        ''SELECT 
				'''''+@RucE+''''',Ejer,NroCta,NomCta,Nivel,IB_Aux,IB_CC,IB_DifC,IC_ACV,IC_ASM,IB_GCB,
				IB_Psp,IB_CtaD,IB_MdVta,IB_MdCom,IB_MdCtb,IB_MdTsr,IB_MdPrs,IB_MdInv,Cd_Blc,
				Cd_EGPN,Cd_EGPF,IB_CtasXCbr,IB_CtasXPag,Estado,Cd_Mda,IC_IEF,IC_IEN,NroCtaH1,
				NomCtaH1,NroCtaH2,NomCtaH2,IB_PFC,IB_NDoc,IB_Prod,IB_Imp,IB_Dtr
			from 
				PlanCtas
			where 
				RucE='''''+@RucEBase+''''' and Ejer='''''+@Ejer+''''' '')
'
print @Consulta
Exec(@Consulta)
--Leyenda
--JJ  11/01/2010:<Creacion del Procedimiento>
GO
