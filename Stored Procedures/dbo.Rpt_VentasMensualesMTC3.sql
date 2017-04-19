SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_VentasMensualesMTC3]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@Prdo nvarchar(2)
as


Select * ,''as MesCons, '' as AnioCons from Empresa Where Ruc = @RucE 

select 
		--i.Cant,
		case when isnull(Serial,'')<>'' then 0 else abs(i.cant) end as Cant,
		i.FecMov,
		i.Cd_Prod,
		p.Nombre1 as Nombre,
		m.Nombre as Descrip,
		p.CodCo1_ as CodCom,
		isnull(sm.Serial,'-') as Serial,
		isnull(p.CA01,'-') as Cd_Homo,
		--i.Cd_Clt,
		case when isnull(i.Cd_Clt,'') = '' then 
												case when isnull(i.Cd_GR,'') <>'' then (select Cd_Clt from GuiaRemision where RucE =@RucE and Cd_GR = i.Cd_GR) 
													 when ISNULL(i.Cd_OP,'') <>'' then (select Cd_Clt from OrdPedido where RucE =@RucE and Cd_OP = i.Cd_OP) end else i.Cd_Clt end as Cd_Clt,
		Case when isnull(c.RSocial,'')<>'' then c.RSocial else c.ApPat +' '+c.ApMat+' '+c.Nom end as Cliente,
		c.NDoc as RucCli,
		c.Direc as DirecCli
		from inventario i
		inner join producto2 p on p.ruce = i.ruce and p.cd_prod = i.cd_prod
		left join Cliente2 c on c.ruce = i.RucE and c.Cd_Clt = case when isnull(i.Cd_Clt,'') = '' then 
															case when isnull(i.Cd_GR,'') <>'' then (select Cd_Clt from GuiaRemision where RucE =@RucE and Cd_GR = i.Cd_GR) 
																 when ISNULL(i.Cd_OP,'') <>'' then (select Cd_Clt from OrdPedido where RucE =@RucE and Cd_OP = i.Cd_OP) end else i.Cd_Clt end
		left join serialmov sm on sm.ruce = i.RucE and sm.Cd_Inv = i.Cd_Inv and sm.Cd_Prod = i.Cd_Prod
		left join marca m on m.RucE = i.RucE and m.Cd_Mca = p.Cd_Mca
		where i.RucE = @RucE and i.Ejer = @Ejer and RIGHT(LEFT(i.RegCtb, 9),2) = @Prdo 
		and i.IC_ES = 'S' 
		and isnull(p.CA01, '') <> ''
		and i.Cd_TO = '01'
		Order by  sm.serial


-- Creado  RG <27/02/2013> 
-- Exec Rpt_VentasMensualesMTC3 '20522276236', '2013', '02'
-- Exec Rpt_VentasMensualesMTC3 RUC__EMPRESA,   EJER,  PRDO

GO
