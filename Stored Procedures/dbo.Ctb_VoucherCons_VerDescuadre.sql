SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[Ctb_VoucherCons_VerDescuadre]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@RegCtb nvarchar(15),
@msj varchar(100) output
as

Select RegCtb,Sum(MtoD-MtoH) As SaldoMN,Sum(MtoD_ME-MtoH_ME) As SaldoME From Voucher 
Where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb
Group by RegCtb

----------------------LEYENDA----------------------
--DI: LUN  17/10/11 -->Creacion del procedimiento almacenado

GO
