SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Ctb_AuxiliarCons_X_TDI]
@RucE nvarchar(11),
@Cd_TDI nvarchar(2),
@TipCons int,
@msj varchar(100) output
as
/*if not exists (select top 1 * from Cliente where RucE=@RucE)
	set @msj = 'No se encontro Cliente'
else  */




/* --Esto era para la version Anterior V1

	if(@TipCons=0)
	    begin
		select a.RucE,a.Cd_Aux as Cd_Cte,b.NCorto as NCortoTDI,a.NDoc,a.RSocial,a.ApPat,a.ApMat,a.Nom,
		          a.Cd_Pais,a.CodPost,a.Ubigeo,a.Direc,a.Telf1,a.Telf2,a.Fax,a.Correo,a.PWeb,a.Estado
                 	          from Auxiliar a, TipDocIdn b where a.RucE=@RucE and a.Cd_TDI=b.Cd_TDI and a.Cd_TDI = @Cd_TDI
	    end
	else if (@TipCons=1) 
	    begin
		select case(isnull(len(a.RSocial),0))
	                     when 0 then a.NDoc+'  |  '+a.ApPat+' '+a.ApMat+' '+a.Nom
		       else a.NDoc+'  |  '+a.RSocial end as CodNom,
		       a.Cd_Aux as Cd_Aux
		       from Auxiliar a, TipDocIdn b where a.RucE=@RucE and a.Cd_TDI=b.Cd_TDI and a.Cd_TDI = @Cd_TDI and a.Estado=1
	    end
	else if (@TipCons=2)
	    begin
		select a.RucE,a.Cd_Aux as Cd_Cte,b.NCorto as NCortoTDI,a.NDoc,a.RSocial,a.ApPat,a.ApMat,a.Nom,
		          a.Cd_Pais,a.CodPost,a.Ubigeo,a.Direc,a.Telf1,a.Telf2,a.Fax,a.Correo,a.PWeb,a.Estado
                       from Auxiliar a, TipDocIdn b where a.RucE=@RucE and a.Cd_TDI=b.Cd_TDI and a.Cd_TDI = @Cd_TDI and a.Estado=1
	    end
	else if (@TipCons=3)
	   begin
	   	select a.Cd_Aux,
		       a.NDoc,
		       case(isnull(len(a.RSocial),0))
	                     when 0 then a.ApPat+' '+a.ApMat+' '+a.Nom
		       else a.RSocial end as Nombre
		       from Auxiliar a, TipDocIdn b where a.RucE=@RucE and a.Cd_TDI=b.Cd_TDI and a.Cd_TDI = @Cd_TDI
	   end

*/


begin
	if(@TipCons=0)
	    begin
		select a.RucE,a.Cd_Aux as Cd_Cte,b.NCorto as NCortoTDI,a.NDoc,a.RSocial,a.ApPat,a.ApMat,a.Nom,
		          a.Cd_Pais,a.CodPost,a.Ubigeo,a.Direc,a.Telf1,a.Telf2,a.Fax,a.Correo,a.PWeb,a.Estado
                 	          from Auxiliar a, TipDocIdn b where a.RucE=@RucE and a.Cd_TDI=b.Cd_TDI and a.Cd_TDI = @Cd_TDI
	    end
	else if (@TipCons=1) 
	    begin
		select case(isnull(len(a.RSocial),0))
	                     when 0 then a.NDoc+'  |  '+a.ApPat+' '+a.ApMat+' '+a.Nom
		       else a.NDoc+'  |  '+a.RSocial end as CodNom,
		       a.Cd_Aux as Cd_Aux
		       from Auxiliar a, TipDocIdn b where a.RucE=@RucE and a.Cd_TDI=b.Cd_TDI and a.Cd_TDI = @Cd_TDI and a.Estado=1
	    end
	else if (@TipCons=2)
	    begin
		select a.RucE,a.Cd_Aux as Cd_Cte,b.NCorto as NCortoTDI,a.NDoc,a.RSocial,a.ApPat,a.ApMat,a.Nom,
		          a.Cd_Pais,a.CodPost,a.Ubigeo,a.Direc,a.Telf1,a.Telf2,a.Fax,a.Correo,a.PWeb,a.Estado
                       from Auxiliar a, TipDocIdn b where a.RucE=@RucE and a.Cd_TDI=b.Cd_TDI and a.Cd_TDI = @Cd_TDI and a.Estado=1
	    end
	else if (@TipCons=3)
	   begin
	   	select a.Cd_Aux,
		       a.NDoc,
		       case(isnull(len(a.RSocial),0))
	                     when 0 then a.ApPat+' '+a.ApMat+' '+a.Nom
		       else a.RSocial end as Nombre
		       from Vst_Auxiliar_CltPrv a, TipDocIdn b where a.RucE=@RucE and a.Cd_TDI=b.Cd_TDI and a.Cd_TDI = @Cd_TDI
	   end
end
print @msj


GO
