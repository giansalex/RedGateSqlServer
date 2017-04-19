SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_OdenPConsUn]
@RucE nvarchar(11),
@Cd_OP nvarchar(10),
@msj varchar(100) output
as
if not exists (select * from OrdenP where RucE=@RucE and Cd_OP=@Cd_OP)
	set @msj = 'No existe Orden de Pedido'
begin
	select 
		op.RucE, op.Cd_OP, op.NroOP, op.FecE, op.Cd_FPC, fp.Nombre as 'F.Pago', op.Cd_Vdr, 
		case(isnull(len(av.RSocial),0))
	    		when 0 then av.ApPat+' '+av.ApMat+' '+av.Nom
	    		else av.RSocial end as NomCompVdr,
		op.Cd_Area, ar.Descrip as Area,	op.Cd_MR, md.Nombre as Modulo, op.Cd_Cte,
		case(isnull(len(ac.RSocial),0))
	    		   	when 0 then ac.ApPat+' '+ac.ApMat+' '+ac.Nom
	    		     	else ac.RSocial end as NomCompCte,
		op.DirecEnt, op.FecEnt, op.Obs, op.Imp, op.IGV, op.Total, op.Cd_Mda, mo.Nombre as Moneda, op.CamMda, op.FecReg,
		op.FecMdf, op.UsuCrea, op.UsuModf, op.IB_Anulado
	from OrdenP op
	inner join FormaPC fp on fp.Cd_FPC=op.Cd_FPC and op.RucE=@RucE and op.Cd_OP=@Cd_OP --and cp.IB_Anulado
	left join Auxiliar av on av.RucE=op.RucE and av.Cd_Aux=op.Cd_Vdr
	inner join Area ar on ar.RucE=op.RucE and ar.Cd_Area=op.Cd_Area
	inner join Modulo md on md.Cd_MR=op.Cd_MR
	left join Auxiliar ac on ac.RucE=op.RucE and ac.Cd_Aux=op.Cd_Cte
	inner join Moneda mo on mo.Cd_Mda=op.Cd_Mda
end
print @msj
GO
