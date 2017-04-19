SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_Servicio2Cons]
@RucE nvarchar(11),
@TipCons int,
@IC_TipServ char(1),
@msj varchar(100) output
as
SET CONCAT_NULL_YIELDS_NULL OFF
/* TIPOS CONSULTA
0: General: select * from Tabla
1: ComboBox: select CodNom, Cd_Entidad from Tabla where Estado=1
2: Activos: select * from Tabla where Estado=1
3: Ayuda: select Cd_Ent,NroDoc,Nombre from Tabla
*/
begin
if @IC_TipServ is null 
	set @IC_TipServ = 'V'


	if(@TipCons=0)
		begin
			select 	
				srv.RucE,srv.Cd_Srv,isnull(srv.CodCo,'') as CodCo,
				srv.Nombre,srv.Descrip,srv.Cta1,srv.Cta2,srv.Cta3,srv.Cta4,srv.Cta5,srv.Cta6,srv.Cta7,srv.Cta8,
				gpoSrv.Descrip 'GrpDescrip' ,srv.Cd_CC,srv.Cd_SC,srv.Cd_SS,srv.UsuCrea,srv.UsuMdf,srv.Estado
			from
				Servicio2 srv

			left join GrupoSrv gpoSrv on gpoSrv.RucE = srv.RucE and gpoSrv.Cd_GS=srv.Cd_GS
			--left join CCostos cc on cc.RucE = srv.RucE and cc.Cd_CC=srv.Cd_CC
			--left join CCSub sc on sc.RucE = srv.RucE and cc.Cd_CC=srv.Cd_CC and sc.Cd_SC = srv.Cd_SC
			--left join CCSubSub ssc on ssc.RucE = srv.RucE and cc.Cd_CC=srv.Cd_CC and sc.Cd_SC = srv.Cd_SC and ssc.Cd_SS = srv.Cd_SS

			Where 
				srv.RucE=@RucE and IC_TipServ=@IC_TipServ

		end
	else if (@TipCons=1) ---CORREGIR
	    	begin
			
	select * from Servicio2
			if (@RucE='20523031687')
				select 	isnull(srv.CodCo,'')+' | '+isnull(srv.Nombre,'') as CodNom,isnull(srv.CodCo,'')as CodCo,isnull(srv.Nombre,'') as Nombre
				from Servicio2 srv
				left join GrupoSrv gpoSrv on gpoSrv.RucE = srv.RucE and gpoSrv.Cd_GS=srv.Cd_GS
				---left join PrecioSrv pr on pr.RucE=srv.RucE and pr.Cd_Srv=srv.Cd_Srv
				where srv.RucE=@RucE and srv.Estado=1 and IC_TipServ=@IC_TipServ
			else
				select srv.Cd_Srv+' | '+srv.Nombre as CodNom,srv.Cd_Srv,srv.Nombre 
				from Servicio2 srv
				left join GrupoSrv gpoSrv on gpoSrv.RucE = srv.RucE and gpoSrv.Cd_GS=srv.Cd_GS
				---left join PrecioSrv pr on pr.RucE=srv.RucE and pr.Cd_Srv=srv.Cd_Srv
				where srv.RucE=@RucE and srv.Estado=1 and IC_TipServ=@IC_TipServ
		end
	else if (@TipCons=2)---CORREGIR
	    begin
			declare @check bit
			set @check=0
				/*select 	srv.RucE,srv.Cd_Srv,srv.CodCo,srv.Nombre,srv.Descrip,
				srv.Cta1,srv.Cta2,pr.PVta,pr.IB_IncIGV,pr.ValVta,
				case(pr.IC_TipDscto) 
				when 'I' 
				then 'Importe' 
				when 'P'
				then 'Porcentual' 
				else ''
				end as TipDcto,pr.Dscto,srv.Estado
				
				from
				Servicio2 srv

				left join PrecioSrv pr on pr.RucE=srv.RucE and pr.Cd_Srv=srv.Cd_Srv
			
				Where
				srv.RucE=@RucE and srv.Estado=1*/
			select @check as Sel,Cd_Srv as Codigo, Nombre from Servicio2 Where RucE=@RucE and IC_TipServ=@IC_TipServ
	    end
	else if (@TipCons=3)---CORREGIR
	    begin		 
		if (@RucE='20523031687')
			select 	
				isnull(srv.CodCo,'')as CodCo,isnull(srv.CodCo,'') as CodCo,srv.Nombre 
				
			from Servicio2 srv
			left join PrecioSrv pr on pr.RucE=srv.RucE and pr.Cd_Srv=srv.Cd_Srv
			
			where 
				srv.RucE=@RucE and srv.Estado=1 and IC_TipServ=@IC_TipServ
		else
			select	
				srv.Cd_Srv,srv.Cd_Srv,srv.Nombre 
			from Servicio2 srv
			left join GrupoSrv gpoSrv on gpoSrv.RucE = srv.RucE and gpoSrv.Cd_GS=srv.Cd_GS
 			---left join PrecioSrv pr on pr.RucE=srv.RucE and pr.Cd_Srv=srv.Cd_Srv
			where 
				srv.RucE=@RucE and srv.Estado=1 and IC_TipServ=@IC_TipServ
	    end
end
print @msj

GO
