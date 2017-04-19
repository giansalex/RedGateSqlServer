SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_Vendedor2Cons_X_TDI]
@RucE nvarchar(11),
@Cd_TDI nvarchar(2),
@TipCons int,
@msj varchar(100) output
as

    /*
     0: General: select * from Tabla
     1: ComboBox: select CodNom, Cd_Entidad from Tabla where Estado=1
     2: Activos: select * from Tabla where Estado=1
     3: Ayuda: select Cd_Ent,NroDoc,Nombre from Tabla
     */


begin
	if(@TipCons=0)
	    begin
		select vnd.RucE,vnd.Cd_Vdr,tdi.NCorto,vnd.NDoc,
		vnd.ApPat,vnd.ApMat,vnd.Nom,vnd.Ubigeo,cgv.Descrip as CGVDesc,ct.Descrip as CtDesc,
		vnd.Direc,vnd.Telf1,vnd.Telf2,vnd.Correo,vnd.Cargo,vnd.Estado
		from Vendedor2 vnd
		left join TipDocIdn tdi on tdi.Cd_TDI=vnd.Cd_TDI
		left join ComisionGrupVdr cgv on cgv.Cd_CGV= vnd.Cd_CGV 
		left join CarteraProd ct on ct.Cd_Ct=vnd.Cd_Ct and ct.RucE=vnd.RucE
		Where vnd.RucE=@RucE and vnd.Cd_TDI=@Cd_TDI

	    end
	else if (@TipCons=1) 
	    begin
		select vnd.NDoc+'  |  '+isnull(vnd.ApPat,'')+' '+isnull(vnd.ApMat,'')+' '+isnull(vnd.Nom,'')  as CodVnd,Cd_Vdr
		from Vendedor2 vnd
--		left join TipDocIdn tdi on tdi.Cd_TDI=vnd.Cd_TDI and tdi.Estado=1 
--		left join ComisionGrupVdr cgv on cgv.Cd_CGV= vnd.Cd_CGV and cgv.Estado=1 
--		left join CarteraProd ct on ct.Cd_Ct=vnd.Cd_Ct and ct.RucE=vnd.RucE and ct.Estado=1
		Where vnd.RucE=@RucE and vnd.Cd_TDI=@Cd_TDI and vnd.Estado=1

	    end
	else if (@TipCons=2)
	    begin
		select vnd.RucE,vnd.Cd_Vdr,tdi.NCorto,vnd.NDoc,
		vnd.ApPat,vnd.ApMat,vnd.Nom,vnd.Ubigeo,cgv.Descrip as CGVDesc,ct.Descrip as CtDesc,
		vnd.Direc,vnd.Telf1,vnd.Telf2,vnd.Correo,vnd.Cargo,vnd.Estado
		from Vendedor2 vnd
		left join TipDocIdn tdi on tdi.Cd_TDI=vnd.Cd_TDI and tdi.Estado=1 
		left join ComisionGrupVdr cgv on cgv.Cd_CGV= vnd.Cd_CGV and cgv.Estado=1 
		left join CarteraProd ct on ct.Cd_Ct=vnd.Cd_Ct and ct.RucE=vnd.RucE and ct.Estado=1
		Where vnd.RucE=@RucE and vnd.Cd_TDI=@Cd_TDI and vnd.Estado=1

	    end
	else if (@TipCons=3)
	   begin
	   	select vnd.Cd_Vdr,
		vnd.NDoc,
		case(isnull(len(vnd.RSocial),0)) when 0 then isnull(nullif(isnull(vnd.ApPat,'') +' '+isnull(vnd.ApMat,'')+' '+isnull(vnd.Nom,''),''),'------- SIN NOMBRE ------') else vnd.RSocial end as Nombre
--		vnd.ApPat+' '+vnd.ApMat+' '+vnd.Nom
		from Vendedor2 vnd
--		left join TipDocIdn tdi on tdi.Cd_TDI=vnd.Cd_TDI
--		left join ComisionGrupVdr cgv on cgv.Cd_CGV= vnd.Cd_CGV 
--		left join CarteraProd ct on ct.Cd_Ct=vnd.Cd_Ct and ct.RucE=vnd.RucE
		Where vnd.RucE=@RucE and vnd.Cd_TDI=@Cd_TDI

	   end
end
print @msj
-- J 12/03/10 -> creacion
--PV:  Dom 14/11/2010  Mdf: Estaban mal consultas TipCons 1 y 3

--exec Vta_Vendedor2Cons_X_TDI '20100286981', '00', '3',''
--exec Vta_Vendedor2Cons_X_TDI '20100286981', '01', '3',''

--exec Inv_MtvoIngSalCons_x_TM '20100286981', '02', ''
GO
