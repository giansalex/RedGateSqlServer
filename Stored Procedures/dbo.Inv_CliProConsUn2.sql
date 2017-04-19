SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [dbo].[Inv_CliProConsUn2] -- Consulta todos los clientes o proveedores que esten asociados a una Guia de Remision
@RucE nvarchar(11),
--@Cd_Clt char(10), NO ES NECESARIOOOOO!!
--@Cd_Prv char(10), NO ES NECESARIOOOOO!!
--@Cd_TD nvarchar(2),
@Cd_GR char(10),
@msj varchar(100) output
as
begin


declare @Cd_Clt char(10), @Cd_Prv char(10), @IC_ES char(1)

select @Cd_Clt = Cd_Clt from GuiaRemision where RucE=@RucE and Cd_GR=@Cd_GR
select @Cd_Prv = Cd_Prv from GuiaRemision where RucE=@RucE and Cd_GR=@Cd_GR
select @IC_ES = IC_ES from GuiaRemision where RucE=@RucE and Cd_GR=@Cd_GR

		declare @IndNroAux int
		-- compruebo cuantos auxiliares tiene relacionada una GR (uno/varios) -- ya sea que existen varias ventas con el mismo auxiliar
		if @IC_ES = 'S'
		begin			
				select @IndNroAux = count(Cd_GR) from (select Cd_GR from GuiaXVenta g, Venta v where g.ruce=@RucE and g.RucE =v.RucE and Cd_GR=@Cd_GR and g.Cd_Vta =v.Cd_Vta 
				group by Cd_GR, Cd_Clt) as Ventas			
		end
		else --if @IC_ES = 'E'
		begin
			select @IndNroAux = count(Cd_GR) from (select Cd_GR from GuiaXCompra g, Compra c where g.ruce=@RucE and g.RucE =c.RucE and Cd_GR=@Cd_GR and g.Cd_Com =c.Cd_Com 
			group by Cd_GR, Cd_Prv) as Compras
		end
		

		--print 'indicador nro Aux: ' + convert(varchar,@IndNroAux)
		
	 	
	if(@IC_ES = 'S')
	begin
		if(@Cd_Prv is not null )
		begin
			if @IndNroAux>1 
				select '' as Cd_Aux, '00' as Cd_TDI, 'Varios' as NDoc, 'Varios' as NomAux
			else 
			begin
				--sacamos al prv
				select @Cd_Prv=Cd_Prv from GuiaRemision where RucE=@RucE and Cd_GR=@Cd_GR
				
				--select Cd_TDI,NDoc,Nom,ApPat,ApMat,RSocial,@IndNroAux as Indicador from Cliente2 where RucE=@RucE and Cd_Clt=@Cd_Clt
				select Cd_Prv as Cd_Aux, Cd_TDI,NDoc, case(isnull(len(RSocial),0)) when 0 then isnull(nullif(ApPat +' '+ApMat+' '+Nom,''),'------- SIN NOMBRE ------') else RSocial end as NomAux from Proveedor2 where RucE=@RucE and Cd_Prv=@Cd_Prv
			end
		end
		else --cd_clt
		begin
			if @IndNroAux>1 
				select '' as Cd_Aux, '00' as Cd_TDI, 'Varios' as NDoc, 'Varios' as NomAux
			else 
			begin
				--sacamos el cliente de donde este
				select @Cd_Clt=Cd_Clt from GuiaRemision where RucE=@RucE and Cd_GR=@Cd_GR
				if @Cd_Clt is null
				begin
					select @Cd_Clt=Cd_Clt from GuiaxVenta gv, venta v where gv.RucE=@RucE and gv.Cd_GR=@Cd_GR and v.RucE=gv.ruce and v.Cd_Vta = gv.Cd_Vta			
					--(es mejor usar la de arriba) set @Cd_Clt = (select Cd_Clt from GuiaxVenta gv, venta v where gv.RucE=@RucE and gv.Cd_GR=@Cd_GR and v.RucE=gv.ruce and v.Cd_Vta = gv.Cd_Vta)
				end
				--select Cd_TDI,NDoc,Nom,ApPat,ApMat,RSocial,@IndNroAux as Indicador from Cliente2 where RucE=@RucE and Cd_Clt=@Cd_Clt
				select Cd_Clt as Cd_Aux, Cd_TDI,NDoc, case(isnull(len(RSocial),0)) when 0 then isnull(nullif(ApPat +' '+ApMat+' '+Nom,''),'------- SIN NOMBRE ------') else RSocial end as NomAux from Cliente2 where RucE=@RucE and Cd_Clt=@Cd_Clt
			end			
		end		
	end
	else --if @IC_ES = 'E'
	begin		

		--select Cd_TDI,NDoc,Nom,ApPat,ApMat,RSocial from Proveedor2 where RucE=@RucE and Cd_Prv=@Cd_Prv

		--if @IndNroAux>1 
			--select '' as Cd_Aux, '00' as Cd_TDI, 'Varios' as NDoc, 'Varios' as NomAux
		--else 
		--begin
			--sacamos el Proveedor de donde este
			select @Cd_Prv=Cd_Prv from GuiaRemision where RucE=@RucE and Cd_GR=@Cd_GR
			if @Cd_Prv is null
			begin
				select @Cd_Prv=Cd_Prv from GuiaxCompra gc, Compra c where gc.RucE=@RucE and gc.Cd_GR=@Cd_GR and c.RucE=gc.RucE and c.Cd_Com = gc.Cd_Com			
				--(es mejor usar la de arriba) set @Cd_Clt = (select Cd_Clt from GuiaxVenta gv, venta v where gv.RucE=@RucE and gv.Cd_GR=@Cd_GR and v.RucE=gv.ruce and v.Cd_Vta = gv.Cd_Vta)
			end
			--select Cd_TDI,NDoc,Nom,ApPat,ApMat,RSocial,@IndNroAux as Indicador from Cliente2 where RucE=@RucE and Cd_Clt=@Cd_Clt
			select Cd_Prv as Cd_Aux, Cd_TDI,NDoc, case(isnull(len(RSocial),0)) when 0 then isnull(nullif(ApPat +' '+ApMat+' '+Nom,''),'------- SIN NOMBRE ------') else RSocial end as NomAux from Proveedor2 where RucE=@RucE and Cd_Prv=@Cd_Prv
		--end

	end


end





print @msj
GO
