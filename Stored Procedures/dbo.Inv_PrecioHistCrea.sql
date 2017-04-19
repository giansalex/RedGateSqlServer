SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_PrecioHistCrea]
@RucE nvarchar(11),
@Id_Prec int,
--@Fecha smalldatetime,
@PVta numeric(13,2),
@IB_IncIGV bit,
@IB_Exrdo bit,
@ValVta numeric(13,2),
@IC_TipDscto char(1),
@Dscto numeric(13,2),
@msj varchar(100) output
as

insert into PrecioHist (RucE,Id_PHist,Id_Prec,Fecha,PVta,IB_IncIGV,IB_Exrdo,ValVta,IC_TipDscto,Dscto)
	values (@RucE,  dbo.Id_PHist(@RucE),@Id_Prec,getdate(),@PVta,@IB_IncIGV,@IB_Exrdo,@ValVta,@IC_TipDscto,@Dscto)
if @@rowcount <= 0
	set @msj = 'Precio no pudo ser registrado'	

-- Leyenda --
-- PP : 2010-03-19 10:41:20	: <Creacion del procedimiento almacenado>
-- PP : 2010-03-19 12:02:58.023	: <Modificacion del procedimiento almacenado por el Id_Prec>


GO
