SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE procedure [dbo].[Vta_ClienteCons_X_TDI]
@RucE nvarchar(11),
@Cd_TDI nvarchar(2),
@TipCons int,
@msj varchar(100) output

as
/*if not exists (select top 1 * from Cliente where RucE=@RucE)
	set @msj = 'No se encontro Cliente'
else  */

SET CONCAT_NULL_YIELDS_NULL off --Para que se pueda concatenar NULLs --PV 

begin
	if(@TipCons=0)
	    begin
		select a.RucE,a.Cd_Aux as Cd_Cte,b.NCorto as NCortoTDI,a.NDoc,a.RSocial,a.ApPat,a.ApMat,a.Nom,
		          a.Cd_Pais,a.CodPost,a.Ubigeo,a.Direc,a.Telf1,a.Telf2,a.Fax,a.Correo,a.PWeb,c.Cta,a.Estado
                 	          from Auxiliar a, TipDocIdn b, Cliente c where a.RucE=@RucE and a.Cd_Aux=c.Cd_Aux and a.RucE=c.RucE and a.Cd_TDI=b.Cd_TDI and a.Cd_TDI = @Cd_TDI
	    end
	else if (@TipCons=1) 
	    begin
		select case(isnull(len(a.RSocial),0))
	                     when 0 then a.NDoc+'  |  '+a.ApPat+' '+a.ApMat+' '+a.Nom
		       else a.NDoc+'  |  '+a.RSocial end as CodNom,
		       a.Cd_Aux as Cd_Cte
		       from Auxiliar a, TipDocIdn b, Cliente c where a.RucE=@RucE and a.Cd_Aux=c.Cd_Aux and a.RucE=c.RucE and a.Cd_TDI=b.Cd_TDI and a.Cd_TDI = @Cd_TDI and a.Estado=1 and c.Estado=1
	    end
	else if (@TipCons=2)
	    begin
		select a.RucE,a.Cd_Aux as Cd_Cte,b.NCorto as NCortoTDI,a.NDoc,a.RSocial,a.ApPat,a.ApMat,a.Nom,
		          a.Cd_Pais,a.CodPost,a.Ubigeo,a.Direc,a.Telf1,a.Telf2,a.Fax,a.Correo,a.PWeb,c.Cta,a.Estado
                       from Auxiliar a, TipDocIdn b, Cliente c where a.RucE=@RucE and a.Cd_Aux=c.Cd_Aux and a.RucE=c.RucE and a.Cd_TDI=b.Cd_TDI and a.Cd_TDI = @Cd_TDI and a.Estado=1 and c.Estado=1
	    end
	else if (@TipCons=3)
	    begin

		if(@RucE='20507826467') ---PV: Empresa "CASA AMARILLA" *Obs: se debe poder consultar en ayuda por el codigo_Nombre del hijo (CA01 + CA02)
		begin --PV

		   	select a.Cd_Aux as Cd_Cte, a.NDoc, --a.CA01 as NDoc,
			       case(isnull(len(a.CA01),0)) 
				when 0 then
				       case(isnull(len(a.RSocial),0))
						when 0 then isnull(nullif(a.ApPat +' '+a.ApMat+' '+a.Nom,''),'------- SIN NOMBRE ------') --PV
				       else a.RSocial end 
				else '* '+ a.CA01 +' - '+ a.CA02 end 
			       as Nombre
			       --a.CA01 +' - '+ a.CA02 as Nombre 
--			       from Auxiliar a, TipDocIdn b, Cliente c where a.RucE=@RucE and a.Cd_Aux=c.Cd_Aux and a.RucE=c.RucE and a.Cd_TDI=b.Cd_TDI and a.Cd_TDI = @Cd_TDI
			       from Auxiliar a, Cliente c where a.RucE=@RucE and a.Cd_TDI = @Cd_TDI and a.RucE=c.RucE and a.Cd_Aux=c.Cd_Aux and c.Estado=1 --and isnull(a.CA01,'')!=''
			union
		   	select a.Cd_Aux as Cd_Cte, a.NDoc, --a.CA01 as NDoc,
			       '* '+ a.CA04 +' - '+ a.CA05 as Nombre 
			       from Auxiliar a, Cliente c where a.RucE=@RucE and a.Cd_TDI = @Cd_TDI and a.RucE=c.RucE and a.Cd_Aux=c.Cd_Aux and c.Estado=1 and isnull(a.CA04,'')!=''
			union
		   	select a.Cd_Aux as Cd_Cte, a.NDoc, --a.CA01 as NDoc,
			       '* '+ a.CA07 +' - '+ a.CA08 as Nombre 
			       from Auxiliar a, Cliente c where a.RucE=@RucE and a.Cd_TDI = @Cd_TDI and a.RucE=c.RucE and a.Cd_Aux=c.Cd_Aux and c.Estado=1 and isnull(a.CA07,'')!=''

		end
		else --PV
		begin
		   	select a.Cd_Aux as Cd_Cte, a.NDoc,
			       case(isnull(len(a.RSocial),0))
--					when 0 then a.ApPat+' '+a.ApMat+' '+a.Nom
					when 0 then isnull(nullif(a.ApPat +' '+a.ApMat+' '+a.Nom,''),'------- SIN NOMBRE ------') --PV
			       else a.RSocial end as Nombre
			       from Auxiliar a, TipDocIdn b, Cliente c where a.RucE=@RucE and a.Cd_Aux=c.Cd_Aux and a.RucE=c.RucE and a.Cd_TDI=b.Cd_TDI and a.Cd_TDI = @Cd_TDI
		end

	    end
end
print @msj
------CODIGO DE MODIFICACION--------
--CM=MG01

--Pruebas:
-- exec Vta_ClienteCons_X_TDI '11111111111','01',3,null

------------------------------------------------------------


--PV Vie 03/09/2010 Mdf: se agrego SET CONCAT_NULL_YIELDS_NULL - Caso 1: No salia los nombres de las personas que tenian apellido null en TipCons=3
			 -- Caso 2: Personalizacion para empresa "CASA AMARILLA"
			 -- Caso 3: Se agrego para que salga "--- SIN NOMBRE ---" cuando no se haya definido RSocial ni Nombres de aux -- isnull(nullif(..)..)
GO
