SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Rpt_Compra_OrdPedido]
@RucE nvarchar(11),
@Cd_OP nvarchar(10),
@msj varchar(100) output
as

SET CONCAT_NULL_YIELDS_NULL OFF
/**************************CABECERA************************************************/
select 
	/***********Empresa******************************************************/
	e.Ruc,e.RSocial as RSocialEmp,e.Direccion as DirecEmp,e.Telef as TelefEmp,
	/***********Orden Pedido*************************************************/
	op.Cd_OP,op.NroOP,convert(varchar,op.FecE,103) as FecEmi,convert(varchar,op.FecEnt,103) as FecEnt,op.DirecEnt,
	op.Obs,op.Valor as ValorOP, 
	case(IsNull(op.TotDsctoP,0)) when 0 then op.TotDsctoI else op.TotDsctoP end as DsctoTot,
	op.ValorNeto as ValorNetoOP,
	case(IsNull(op.DsctoFnzInf_P,0)) when 0 then op.DsctoFnzInf_I else op.DsctoFnzInf_P end as DsctoFnz,
	op.BIM as BIM_OC,IsNull(op.IGV,'0.00') as IGV_OP,op.Total as Total_OP, op.CamMda,
 	op.AutorizadoPor,
	convert(varchar,op.FecReg,103) as FecReg,
	convert(varchar,op.FecMdf,103) as FecMdf, 
	op.UsuCrea,op.UsuMdf,
	op.CA01 as OCA01,op.CA02 as OCA02, op.CA03 as OCA03,op.CA04 as OCA04,
	op.CA05 as OCA05,op.CA06 as OCA06,op.CA07 as OCA07,op.CA08 as OCA08,
	op.CA09 as OCA09,op.CA10 as OCA10,

	op.Cd_Mda,mda.Nombre as NomMda,mda.Simbolo as SimMda,
	op.Cd_FPC,fpc.Nombre as NombreFPC,fpc.NCorto as NCortoFPC,
	op.Cd_Area,a.Descrip as DescripArea,a.NCorto as NCortoArea,
	clt.NDoc as NDoc,
	case(isnull(len(clt.RSocial),0)) when 0 then clt.ApPat +' '+ clt.ApMat +','+ clt.Nom else clt.RSocial end as NombCli
	,clt.Direc as DirecCli,clt.Telf1 as TlfCli1, clt.Telf2 as  TlfCli2
	,clt.CA01 as CA01Cli,clt.CA02 as CA02Cli,clt.CA03 as CA03Cli,clt.CA04 as CA04Cli,clt.CA05 as CA05Cli
	,clt.CA06 as CA06Cli ,clt.CA07 as CA07Cli ,clt.CA08 as CA08Cli ,clt.CA09 as CA09Cli ,clt.CA10 as CA10Cli

from OrdPedido op
	Left Join Empresa e on e.Ruc=op.RucE	
	Left Join Moneda mda on mda.Cd_Mda = op.Cd_Mda
	Left Join FormaPC fpc on fpc.Cd_FPC = op.Cd_FPC
	Left Join Area a on a.RucE= op.RucE and a.Cd_Area = op.Cd_Area
	Left Join Usuario usu on usu.NomUsu = op.UsuCrea
	left join Cliente2 clt on clt.RucE = op.RucE and clt.Cd_Clt = op.Cd_Clt 
	where op.RucE=@RucE and op.Cd_Op=@Cd_OP




/*******************************DETALLE*******************************************************/
select 
	det.RucE,det.Cd_OP,det.Item,
	det.Descrip as DescripDet,det.PU,det.Cant,det.Valor,det.DsctoP,det.DsctoI,det.BIM,IsNull(det.IGV,'0.00')as IGV,det.Total,det.PendEnt,

	det.Obs as ObsDet,convert(varchar,det.FecMdf,103) as FecMdf,det.UsuMdf,det.CA01 as DCA01,det.CA02 as DCA02,
	det.CA03 as DCA03,det.CA04 as DCA04,det.CA05 as DCA05,
	det.Cd_Prod,pr.Nombre1 as NomProd,pr.Descrip as DescripProd,pr.CodCo1_ as CodComercial,
	det.ID_UMP,ump.DescripAlt,
	um.Cd_UM as CodUM,um.Nombre as NomUM,um.NCorto as NCortoUM
from OrdPedidoDet det
	Left Join Producto2 pr on pr.RucE=det.RucE and pr.Cd_Prod = det.Cd_Prod
	Left Join Prod_UM ump on ump.RucE =det.RucE and ump.ID_UMP = det.ID_UMP and ump.Cd_Prod=pr.Cd_Prod
	Left Join UnidadMedida um on um.Cd_UM = ump.Cd_UM
where det.RucE=@RucE and det.Cd_OP=@Cd_OP

print @msj

/*Leyenda*/
--Javier : <Creado> ---> 04-03-2011
--exec dbo.Rpt_Compra_OrdPedido '11111111111','OP00000002',null





GO
