SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_Cliente2Cons]
@RucE nvarchar(11),
@TipCons int,
@msj varchar(100) output
as
begin
	if(@TipCons=0)
	    begin
		select a.RucE,a.Cd_Clt,b.NCorto as NCortoTDI,a.NDoc,isnull(a.RSocial,(isnull(a.ApPat,'')+' '+isnull(a.ApMat,'')+' '+isnull(a.Nom,''))) as Nombre,
		          a.Cd_Pais,a.CodPost,a.Ubigeo,a.Direc,a.Telf1,a.Telf2,a.Fax,a.Correo,a.PWeb,a.Obs,a.CtaCtb,a.DiasCbr,a.PerCbr,a.CtaCte,a.Cd_CGC,a.Estado,
                 	      a.CA01,a.CA02,a.CA03,a.CA04,a.CA05,a.CA06,a.CA07,a.CA08,a.CA09,a.CA10, a.FecReg, a.UsuCrea, a.FecMdf, a.UsuMdf
				from Cliente2 a inner join TipDocIdn b 
				on a.Cd_TDI = b.Cd_TDI 
				where a.RucE=@RucE
	    end
	else if (@TipCons=1) 
	    begin
		select case(isnull(len(a.RSocial),0))
	                     when 0 then a.NDoc+'  |  '+a.ApPat+' '+a.ApMat+' '+a.Nom
		       else a.NDoc+'  |  '+a.RSocial end as CodNom,
		       a.Cd_Clt
		     	from Cliente2 a inner join TipDocIdn b 
			on a.Cd_TDI = b.Cd_TDI 
			where a.RucE=@RucE and a.Estado=1
	    end
	else if (@TipCons=2)
	    begin
		select a.RucE,a.Cd_Clt,b.NCorto as NCortoTDI,a.NDoc,isnull(a.RSocial,(isnull(a.ApPat,'')+' '+isnull(a.ApMat,'')+' '+isnull(a.Nom,''))) as Nombre,a.Nom,
		          a.Cd_Pais,a.CodPost,a.Ubigeo,a.Direc,a.Telf1,a.Telf2,a.Fax,a.Correo,a.PWeb,a.Obs,a.CtaCtb,a.DiasCbr,a.PerCbr,a.CtaCte,a.Cd_CGC,a.Estado,
                 	      a.CA01,a.CA02,a.CA03,a.CA04,a.CA05,a.CA06,a.CA07,a.CA08,a.CA09,a.CA10, a.FecReg, a.UsuCrea, a.FecMdf, a.UsuMdf 
				from Cliente2 a inner join TipDocIdn b 
				on a.Cd_TDI = b.Cd_TDI 
				where a.RucE=@RucE and a.Estado=1
	    end
	else if (@TipCons=3)
	   begin
	   	select a.Cd_Clt,
		       a.NDoc,
		       case(isnull(len(a.RSocial),0))
	                     when 0 then a.ApPat+' '+a.ApMat+' '+a.Nom
		        else a.RSocial end as Nombre
		        from Cliente2 a inner join TipDocIdn b
			on a.Cd_TDI = b.Cd_TDI 
		        where a.RucE=@RucE
	   end
end
print @msj

GO
