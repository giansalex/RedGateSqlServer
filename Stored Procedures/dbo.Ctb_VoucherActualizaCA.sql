SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Ctb_VoucherActualizaCA]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@Cd_Vou int,
@RegCtb nvarchar(15),
@CA01 varchar(8000),
@CA02 varchar(8000),
@CA03 varchar(8000),
@CA04 varchar(8000),
@CA05 varchar(8000),
@CA06 varchar(8000),
@CA07 varchar(8000),
@CA08 varchar(8000),
@CA09 varchar(8000),
@CA10 varchar(8000),
@CA11 varchar(8000),
@CA12 varchar(8000),
@CA13 varchar(8000),
@CA14 varchar(8000),
@CA15 varchar(8000),
@msj varchar(1000) output
as

update Voucher
set CA01 = @CA01,
CA02 = @CA02,
CA03 = @CA03,
CA04 = @CA04,
CA05 = @CA05,
CA06 = @CA06,
CA07 = @CA07,
CA08 = @CA08,
CA09 = @CA09,
CA10 = @CA10,
CA11 = @CA11,
CA12 = @CA12,
CA13 = @CA13,
CA14 = @CA14,
CA15 = @CA15
where RucE = @RucE and Cd_Vou >= @Cd_Vou and RegCtb = @RegCtb

GO
