SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_Vendedor2Cons]
@RucE nvarchar(11),
@TipCons int,
@msj varchar(100) output
as
begin
	if(@TipCons=0)
	    begin
		select vnd.RucE,vnd.Cd_Vdr,tdi.NCorto,vnd.NDoc,
		vnd.ApPat,vnd.ApMat,vnd.Nom,vnd.Ubigeo,cgv.Descrip as CGVDesc,ct.Descrip as CtDesc,
		vnd.Direc,vnd.Telf1,vnd.Telf2,vnd.Correo,vnd.Cargo,vnd.Estado,vnd.CA01,vnd.CA02,vnd.CA03,
		vnd.CA04,vnd.CA05,vnd.CA06,vnd.CA07,vnd.CA08,vnd.CA09,vnd.CA10
		from Vendedor2 vnd
		left join TipDocIdn tdi on tdi.Cd_TDI=vnd.Cd_TDI
		left join ComisionGrupVdr cgv on cgv.Cd_CGV= vnd.Cd_CGV 
		left join CarteraProd ct on ct.Cd_Ct=vnd.Cd_Ct and ct.RucE=vnd.RucE
		Where vnd.RucE=@RucE

	    end
	else if (@TipCons=1) 
	    begin
		select vnd.NDoc+'  |  '+vnd.ApPat+' '+vnd.ApMat+' '+vnd.Nom  as CodVnd,Cd_Vdr
		from Vendedor2 vnd
		left join TipDocIdn tdi on tdi.Cd_TDI=vnd.Cd_TDI and tdi.Estado=1 
		left join ComisionGrupVdr cgv on cgv.Cd_CGV= vnd.Cd_CGV and cgv.Estado=1 
		left join CarteraProd ct on ct.Cd_Ct=vnd.Cd_Ct and ct.RucE=vnd.RucE and ct.Estado=1
		Where vnd.RucE=@RucE and vnd.Estado=1

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
		Where vnd.RucE=@RucE and vnd.Estado=1

	    end
	else if (@TipCons=3)
	   begin
	   	select vnd.Cd_Vdr,vnd.Cd_Vdr,vnd.ApPat+' '+vnd.ApMat+' '+vnd.Nom
		from Vendedor2 vnd
		left join TipDocIdn tdi on tdi.Cd_TDI=vnd.Cd_TDI
		left join ComisionGrupVdr cgv on cgv.Cd_CGV= vnd.Cd_CGV 
		left join CarteraProd ct on ct.Cd_Ct=vnd.Cd_Ct and ct.RucE=vnd.RucE
		Where vnd.RucE=@RucE
	   end
end
print @msj
-- J 12/03/10 -> creacion
-- MP : 16-02-2011 : <Modificacion del procedimiento almacenado>
GO
