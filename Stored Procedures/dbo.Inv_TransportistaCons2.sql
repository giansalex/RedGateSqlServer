SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_TransportistaCons2]
@RucE nvarchar(11),
@TipCons int,
@msj varchar(100) output
as
begin
	if(@TipCons=0)
	    begin
		select 	tra.RucE,tra.Cd_Tra,tdi.NCorto,tra.NDoc,tra.RSocial,tra.ApPat,tra.ApMat,tra.Nom,
			tra.Cd_Pais,tra.Ubigeo,tra.Direc,tra.Telf,tra.LicCond,tra.NroPlaca,tra.McaVeh,tra.Estado, tra.UsuCrea, tra.FecReg, tra.UsuMdf, tra.FecMdf
		from 	Transportista tra, TipDocIdn tdi
		Where 	tra.RucE=@RucE and tra.Cd_TDI=tdi.Cd_TDI
	    end
	else if (@TipCons=1) 
	    begin
		select 	case(isnull(len(tra.RSocial),0))
	               	when 0 
			then 
			tra.NDoc+' | '+tra.ApPat+' '+tra.ApMat+' '+tra.Nom
		       	else 
			tra.NDoc+' | '+tra.RSocial 
			end as CodNom
		from 	Transportista tra, TipDocIdn tdi 
		where 	tra.RucE=@RucE and tra.Cd_TDI=tdi.Cd_TDI and tra.Estado=1
	    end
	else if (@TipCons=2)
	    begin
		select 	tra.RucE,tra.Cd_Tra,tdi.NCorto,tra.NDoc,tra.RSocial,tra.ApPat,tra.ApMat,tra.Nom,
			tra.Cd_Pais,tra.Ubigeo,tra.Direc,tra.Telf,tra.LicCond,tra.NroPlaca,tra.McaVeh
                from 	Transportista tra, TipDocIdn tdi 
		where 	tra.RucE=@RucE and tra.Cd_TDI=tdi.Cd_TDI and tra.Estado=1
	    end
	else if (@TipCons=3)
	   begin
	   	select 	tra.Cd_Tra,
		   	tra.NDoc,
		       	case(isnull(len(tra.RSocial),0))
	                    when 0 then tra.ApPat+' '+tra.ApMat+' '+tra.Nom
		       	else tra.RSocial end as Nombre
		from 	Transportista tra, TipDocIdn tdi
		where 	tra.RucE=@RucE and tra.Cd_TDI=tdi.Cd_TDI
	   end
end
print @msj
GO
