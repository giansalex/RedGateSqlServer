SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_EmpCrea]
@Ruc nvarchar(11),
@RSocial varchar(100),
@FecIni smalldatetime,
@Ubigeo nvarchar(6),
@Direccion varchar(100),
@Telef varchar(15),
@Logo image,
@Cd_MdaP nvarchar(2),
@Cd_MdaS nvarchar(2),
@UsuCrea nvarchar(10),
@msj varchar(100) output
as
if exists (select * from Empresa Where Ruc=@Ruc)
	set @msj = 'Ya existe una empresa con este RUC'
else
begin
	insert into Empresa(Ruc,RSocial,FecIni,Ubigeo,Direccion,Telef,Logo,Cd_MdaP,Cd_MdaS)
		     values(@Ruc,@RSocial,@FecIni,@Ubigeo,@Direccion,@Telef,@Logo,@Cd_MdaP,@Cd_MdaS)
	if @@rowcount <= 0
		set @msj = 'Empresa no pudo ser ingresado'
	else
	begin	--Creamos un Periodo para la Empresa
		declare @Ejer nvarchar(4)
		set @Ejer = year(@FecIni)
				insert into Periodo(RucE,Ejer,P00,P01,P02,P03,P04,P05,P06,P07,P08,P09,P10,P11,P12,P13,P14) values(@Ruc, @Ejer,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
		
	        --Le Asignamos un Grupo de Acceso Inicial para este Perfil
		declare @Cd_Prf nvarchar(3)
		select @Cd_Prf=Cd_Prf from Usuario where NomUsu=@UsuCrea
		insert into AccesoE(Cd_Prf,RucE,Cd_GA) values(@Cd_Prf,@Ruc,1)

	        --Creamos un Area General:
		 insert into Area(RucE,Cd_Area,Descrip,NCorto,Estado) values(@Ruc,'010101','GENERAL','GN',1)

	        --Creamos un Centros de Costo Generales:
		insert into CCostos(RucE,Cd_CC,Descrip,NCorto,IB_Psp) values(@Ruc,'01010101','GENERAL','GN',0)
		insert into CCSub(RucE,Cd_CC,Cd_SC,Descrip,NCorto,IB_Psp) values(@Ruc,'01010101','01010101','GENERAL','GN',0)
		insert into CCSubSub(RucE,Cd_CC,Cd_SC,Cd_SS,Descrip,NCorto,IB_Psp) values(@Ruc,'01010101','01010101','01010101','GENERAL','GN',0)

		/*
	         --Creamos los Campos en Configuracion de Venta:
		insert into VentaCfg values(@Ruc,'50','Tipo Cobro','0',1,0)
		insert into VentaCfg values(@Ruc,'51','Area','0',1,0)
		insert into VentaCfg values(@Ruc,'52','Moneda','0',1,0)
		insert into VentaCfg values(@Ruc,'53','Tipo Doc.','0',1,0)
		insert into VentaCfg values(@Ruc,'54','Serie','0',1,0)
		insert into VentaCfg values(@Ruc,'55','Tipo Doc. Iden.','0',1,0)
		insert into VentaCfg values(@Ruc,'56','Vendedor','0',1,0)
		insert into VentaCfg values(@Ruc,'57','C. Costos','0',0,0)
		insert into VentaCfg values(@Ruc,'58','Sub C. Costos','0',0,0)
		insert into VentaCfg values(@Ruc,'59','Sub S. C. Costos','0',0,0)
		insert into VentaCfg values(@Ruc,'60','Direccion Export.','C:\Documents and Settings\Diego\Mis documentos',0,0)
		*/

		--Agregamos Cta General
		select * from PlanCtas
		insert into PlanCtas(RucE,NroCta,NomCta,Nivel,IB_Aux,IB_CC,IB_DifC,IC_ACV,IC_ASM,IB_GCB,IB_Psp,IB_CtaD,IB_MdVta,IB_MdCom,IB_MdCtb,IB_MdTsr,IB_MDPrs,IB_MdInv,Cd_Blc,Cd_EGPN,Cd_EGPF,IB_CtasXCbr,IB_CtasXPag,Estado,Cd_Mda,IC_IEF,IC_IEN,Ejer)
		values(@Ruc,'9999999999','GENERAL',4,0,0,0,'c','s',0,0,0,1,1,1,1,1,1,null,null,null,1,1,1,null,null,null,@Ejer)
		
		insert into PlanCtasDef(RucE,IGV,ISC,QCtg,RCons,Perc,Det,Ret,LCm,DC_MN,DC_ME,DP_MN,DP_ME,DCPer,DCGan,IN_DigCls,Ejer)
		values(@Ruc,'9999999999','9999999999','9999999999','9999999999','9999999999','9999999999','9999999999','9999999999','9999999999','9999999999','9999999999','9999999999','9999999999','9999999999',6,@Ejer)
--le agregue datos adicionales solo para crear la empresa sinai
	end

end
print @msj 
--PV  --> Lun 10/11/08
--DE  --> Vie 26/12/08
--PV  --> Mie 04/03/09 : agregar Cta Grl
--DI   --> Jue 07/01/10 : Modificacion <Se agrego los campso faltantes en insert into PlanCTas...>
--DI   --> Lun 11/01/10 : Modificacion <Se agrego las cabeceras al ingresar PlanCtas y PlanCtasDef...>
GO
