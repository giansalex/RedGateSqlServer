SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_ClienteCons]
@RucE nvarchar(11),
@TipCons int,
@msj varchar(100) output
as
/*if not exists (select top 1 * from Cliente where RucE=@RucE)
	set @msj = 'No se encontro Cliente'
else  */
begin
	if(@TipCons=0)
	    begin
		select a.RucE,a.Cd_Aux as Cd_Cte,b.NCorto as NCortoTDI,a.NDoc,a.RSocial,a.ApPat,a.ApMat,a.Nom,
		          a.Cd_Pais,a.CodPost,a.Ubigeo,a.Direc,a.Telf1,a.Telf2,a.Fax,a.Correo,a.PWeb,c.Cta,a.Estado
                 	          from Auxiliar a, TipDocIdn b, Cliente c where a.RucE=@RucE and a.Cd_Aux=c.Cd_Aux and a.RucE=c.RucE and a.Cd_TDI=b.Cd_TDI
	    end
	else if (@TipCons=1) 
	    begin
		select case(isnull(len(a.RSocial),0))
	                     when 0 then a.NDoc+'  |  '+a.ApPat+' '+a.ApMat+' '+a.Nom
		       else a.NDoc+'  |  '+a.RSocial end as CodNom,
		       a.Cd_Aux as Cd_Cte
		       from Auxiliar a, TipDocIdn b, Cliente c where a.RucE=@RucE and a.Cd_Aux=c.Cd_Aux and a.RucE=c.RucE and a.Cd_TDI=b.Cd_TDI and a.Estado=1 and c.Estado=1
	    end
	else if (@TipCons=2)
	    begin
		select a.RucE,a.Cd_Aux as Cd_Cte,b.NCorto as NCortoTDI,a.NDoc,a.RSocial,a.ApPat,a.ApMat,a.Nom,
		          a.Cd_Pais,a.CodPost,a.Ubigeo,a.Direc,a.Telf1,a.Telf2,a.Fax,a.Correo,a.PWeb,c.Cta,a.Estado
                       from Auxiliar a, TipDocIdn b, Cliente c where a.RucE=@RucE and a.Cd_Aux=c.Cd_Aux and a.RucE=c.RucE and a.Cd_TDI=b.Cd_TDI and a.Estado=1 and c.Estado=1
	    end
	else if (@TipCons=3)
	   begin
	   	if(@RucE='20507826467') --- Casa Amarilla *Obs:
		begin
			select 	a.Cd_Aux as Cd_Cte,a.CA01 as CodigoHijo1,a.CA02 as Nombre from
				Auxiliar a, Cliente b where a.RucE=@RucE and 
				a.Cd_Aux=b.Cd_Aux and a.RucE=b.RucE
		end
		else
		begin
		select 	a.Cd_Aux as Cd_Cte,a.NDoc,case(isnull(len(a.RSocial),0))
			when 0 then a.ApPat+' '+a.ApMat+' '+a.Nom else a.RSocial end as Nombre 
		from 	Auxiliar a, TipDocIdn b, Cliente c 
		where 	a.RucE=@RucE and
 			a.Cd_Aux=c.Cd_Aux and a.RucE=c.RucE
 			and a.Cd_TDI=b.Cd_TDI
		end
	   end
end
print @msj
/*
Obs: 
1.-   en el caso que la empresa casa amarilla tenga registro de mas de un hijo, se procedera
      a hacer una consulta select campo adicional 1 + campo adicional 2 (Datos Hijo 1)  con union campo adicional 3 + campo adicional 4 (Datos Hijo 2)
*/
-- Leyenda
-- JJ   2010-09-01: 	<Modificacion de Store Procedure para Casa Amarilla>



-- PRUEBA BKP FULL 1-- PV- 20110427 MIE 5:16PM
-- PRUEBA BKP DIFF  1-- PV- 20110427 MIE 5:31PM xxx
GO
