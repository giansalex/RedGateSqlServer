SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_Cliente2Cons_X_TDI1]
@RucE nvarchar(11),
@Cd_TDI nvarchar(2),
@TipCons int,
@msj varchar(100) output
as
begin
	if(@TipCons=0)
	    begin
		select a.RucE,a.Cd_Clt,b.NCorto as NCortoTDI,a.NDoc,a.RSocial,a.ApPat,a.ApMat,a.Nom,
		          a.Cd_Pais,a.CodPost,a.Ubigeo,a.Direc,a.Telf1,a.Telf2,a.Fax,a.Correo,a.PWeb,a.Obs,a.CtaCtb,a.DiasCbr,a.PerCbr,a.CtaCte,a.Cd_CGC,a.Estado,
                 	      a.CA01,a.CA02,a.CA03,a.CA04,a.CA05,a.CA06,a.CA07,a.CA08,a.CA09,a.CA10 
				from Cliente2 a inner join TipDocIdn b 
				on a.Cd_TDI = b.Cd_TDI 
				where a.RucE=@RucE and a.Cd_TDI = @Cd_TDI
	    end
	else if (@TipCons=1) 
	    begin
		select case(isnull(len(a.RSocial),0))
	                     when 0 then a.NDoc+'  |  '+a.ApPat+' '+a.ApMat+' '+a.Nom
		       else a.NDoc+'  |  '+a.RSocial end as CodNom,
		       a.Cd_Clt
		     	from Cliente2 a inner join TipDocIdn b 
			on a.Cd_TDI = b.Cd_TDI 
			where a.RucE=@RucE and a.Estado=1 and a.Cd_TDI = @Cd_TDI
	    end
	else if (@TipCons=2)
	    begin
		select a.RucE,a.Cd_Clt,b.NCorto as NCortoTDI,a.NDoc,a.RSocial,a.ApPat,a.ApMat,a.Nom,
			   case(isnull(len(a.RSocial),0))
		       when 0 then isnull(a.ApPat,'')+' '+isnull(a.ApMat,'')+' '+isnull(a.Nom,'')
		   	   else a.RSocial end as Nombre,
		       a.Cd_Pais,a.CodPost,a.Ubigeo,a.Direc,a.Telf1,a.Telf2,a.Fax,a.Correo,a.PWeb,a.Obs,a.CtaCtb,a.DiasCbr,a.PerCbr,a.CtaCte,a.Cd_CGC,a.Estado,
               a.CA01,a.CA02,a.CA03,a.CA04,a.CA05,a.CA06,a.CA07,a.CA08,a.CA09,a.CA10 
				from Cliente2 a inner join TipDocIdn b 
				on a.Cd_TDI = b.Cd_TDI 
				where a.RucE=@RucE and a.Estado=1 and a.Cd_TDI = @Cd_TDI
	    end
	else if (@TipCons=3)
	   begin
		if(@RucE='20100286981') --- Fideos El Triunfo
		begin
			select a.Cd_Clt,
			       a.NDoc,
			       case(isnull(len(a.RSocial),0))
		                     when 0 then isnull(a.CA01,'')+' - '+isnull(a.ApPat,'')+' '+isnull(a.ApMat,'')+' '+isnull(a.Nom,'')
		   		else isnull(a.CA01,'')+' - '+a.RSocial end as Nombre
			        from Cliente2 a inner join TipDocIdn b
				on a.Cd_TDI = b.Cd_TDI 
			        where a.RucE=@RucE and a.Cd_TDI = @Cd_TDI and a.Estado = 1
		end
		if(@RucE='20507826467' or @RucE='20110154764') --- Casa Amarilla *Obs:
		begin
			SELECT TAB.Cd_Clt As Cd_Clt,TAB.NDoc As NDoc,TAB.Nombre As Nombre
			FROM
			(
			Select  a.Cd_Clt,a.NDoc,Case When isnull(len(a.CA01),0)=0 Then case(isnull(len(a.RSocial),0)) when 0 then isnull(nullif(isnull(a.ApPat,'') +' '+isnull(a.ApMat,'')+' '+isnull(a.Nom,''),''),'------- SIN NOMBRE ------') else a.RSocial end else '* '+ a.CA01 +' - '+ a.CA02 end as Nombre from Cliente2 a Where a.RucE=@RucE and a.Cd_TDI=@Cd_TDI and a.Estado=1
			UNION ALL Select  a.Cd_Clt,a.NDoc,'* '+ a.CA04 +' - '+ a.CA05 As Nombre from Cliente2 a Where a.RucE=@RucE and a.Cd_TDI=@Cd_TDI and a.Estado=1
			UNION ALL Select  a.Cd_Clt,a.NDoc,'* '+ a.CA07 +' - '+ a.CA08 As Nombre from Cliente2 a Where a.RucE=@RucE and a.Cd_TDI=@Cd_TDI and a.Estado=1
			) As TAB
			GROUP BY TAB.Cd_Clt,TAB.NDoc,TAB.Nombre
			HAVING isnull(Nombre,'')<>''
			ORDER BY 1
		end
		else
		begin
		   	select a.Cd_Clt,
			       a.NDoc,
			       case(isnull(len(a.RSocial),0))
		                     when 0 then isnull(a.ApPat,'')+' '+isnull(a.ApMat,'')+' '+isnull(a.Nom,'')
		   		else a.RSocial end as Nombre
		   		,b.NCorto as NCortoTDI, a.Direc
			        from Cliente2 a inner join TipDocIdn b
				on a.Cd_TDI = b.Cd_TDI 
			        where a.RucE=@RucE and a.Cd_TDI = @Cd_TDI and a.Estado = 1
		end
	   end
end
print @msj

-- Leyenda --

-- DI : 03/05/2011 <Se egrego la configuracion de campos hijos para casa amarilla>
-- MM : 17/10/2011 <Se modifico para que solo muestre los habilitados>
-- DI : 15/02/2012 <Se el ruc de la empresa Isabel de Orbea en la condicion de casa amarilla>

-- DI : 12/09/2012 <Se cambio la posicion del NCortoTDI -> Generaba error en los modulos de contabilidad>
--				   <¿Quien agrego el cambio NCortoTDI?>
-- JA : 11/02/2013 <Se modifico el Cd_Cte por Cd_Clt, cuando es casa amarilla >
--exec Vta_Cliente2Cons_X_TDI '11111111111','00','3',''
GO
