SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Ctb_VoucherValida1]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@RegCtb nvarchar(15),

@msj varchar(100) output
as
if exists (select top 1 * from Voucher where RucE = @RucE and Ejer=@Ejer and RegCtb=@RegCtb) --and exists (select * from CampoV where RucE=@RucE)
	set @msj = 'Registro Contable ya existe'


print @msj
--PV: MAR 23/11/2010 -- Creacion del procedimiento almacenado



GO
