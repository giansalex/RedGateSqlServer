SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [pvo].[Vta_VentaConsUn]
@RucE nvarchar(11),
@Cd_Vta nvarchar(10),
@msj varchar(100) output
as
IF not exists (select * from Venta where RucE=@RucE and Cd_Vta=@Cd_Vta)
	set @msj = 'Venta no existe'
else
begin

	declare @SldoMN numeric(13,2), @SldoME numeric(13,2), @Total numeric(13,2), @CobMN numeric(13,2), @CobME numeric(13,2), @Cd_MdOrg nvarchar(2), @CamMda numeric(13,3)

	set @Total=0 set @CamMda=0
	set @CobMN=0 set @CobME=0
	set @SldoMN=0 set @SldoME=0
	
	select @Total=Total, @Cd_MdOrg=Cd_Mda, @CamMda=CamMda from Venta where RucE=@RucE and Cd_Vta=@Cd_Vta print @Total
	select @CobMN=isnull(sum(Monto),0), @CobME=isnull(sum(Monto/CamMda),0) from Cobro where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Mda='01' print @CobMN print @CobME
	
	select @CobMN=@CobMN+isnull(sum(Monto*CamMda),0), @CobME=@CobME+isnull(sum(Monto),0) from Cobro where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Mda='02' print @CobMN print @CobME

	--print 'aa'
	
	if @CamMda = 0  ---> NO DEBERIA HABER TIPO DE CAMBIO 0.00
		set @CamMda = 1	   

	if @Cd_MdOrg='01'
	begin	set @SldoMN = @Total - @CobMN
		set @SldoME = @Total/@CamMda - @CobME
		--print 'bb'
	end
	else 
	begin	set @SldoMN = @Total*@CamMda - @CobMN
		set @SldoME = @Total - @CobME
		--print 'cc'
	end

	print 'Saldo MN' print @SldoMN
	print 'Saldo ME' print @SldoME




	select 
		v.RegCtb,
		v.Prdo,
		Convert(varchar,v.FecMov,103) as FecMov,
		v.Cd_TD, d.Descrip as NomTD, 
		v.NroDoc,
		'' as Cd_Sr/*v.Cd_Sr*/, v.NroSre as NroSerie,--s.NroSerie,
		c.Cd_TDI, i.Descrip as NomTDI,
		v.Cd_Clt as Cd_Cte, c.NDoc as NDocCte, case(isnull(len(c.RSocial),0)) when 0 then c.ApPat+' '+c.ApMat+' '+c.Nom else c.RSocial end as NombreCte,
		v.Cd_Vdr, r.NDoc as NDocVdr, case(isnull(len(r.RSocial),0)) when 0 then r.ApPat+' '+r.ApMat+' '+r.Nom else r.RSocial end as NombreVdr,
		v.Cd_Area,a.NCorto as NomArea,
--		e.Cd_MdaP,o.Simbolo as SimboloMP, 
		v.Cd_Mda, m.Simbolo as SimMdRg,
		v.CamMda,
		v.Total,
--		e.Cd_MdaS, u.Simbolo as SimboloMS,
		@SldoMN as SldoMN,
		@SldoME as SldoME,
		
		--DEBERIA REGISTRARSE C.COSTOS EN VENTA Y JALAR ESTOS
		'01010101' as Cd_CC,
		'01010101' as Cd_SC,
		'01010101' as Cd_SS


	from Venta v
		inner join TipDoc d 	on d.Cd_TD=v.Cd_TD
		--inner join Serie s 	on s.RucE=v.RucE and s.Cd_Sr=v.Cd_Sr
--
		--inner join Auxiliar c 	on c.RucE=v.RucE and c.Cd_Aux=v.Cd_Cte
		inner join Cliente2 c	on c.RucE=v.RucE and c.Cd_Clt=v.Cd_Clt
		--left join Cliente2 c	on c.RucE=v.RucE and c.Cd_Clt=v.Cd_Clt
--
		--inner join Auxiliar r 	on r.RucE=v.RucE and r.Cd_Aux=v.Cd_Vdr
		inner join Vendedor2 r	on r.RucE=v.RucE and r.Cd_vdr=v.Cd_Vdr
		--left join Vendedor2 r	on r.RucE=v.RucE and r.Cd_vdr=v.Cd_Vdr
		inner join TipDocIdn i 	on i.Cd_TDI=c.Cd_TDI
		inner join Area a 	on a.RucE = v.RucE  and a.Cd_Area=v.Cd_Area
--		inner join Empresa e 	on e.Ruc=v.RucE 
--		inner join Moneda o 	on o.Cd_Mda=e.Cd_MdaP
--		inner join Moneda u 	on u.Cd_Mda=e.Cd_MdaS
		inner join Moneda m 	on m.Cd_Mda=v.Cd_Mda
	where v.RucE=@RucE and v.Cd_Vta=@Cd_Vta
end
print @msj


--Pruebas
/*
select VT00000261
exec pvo.Vta_VentaConsUn '11111111111','VT00000261',null
*/


--PV: JUE 09/07/2009: Mdf --> se agrego C.Costos



GO
