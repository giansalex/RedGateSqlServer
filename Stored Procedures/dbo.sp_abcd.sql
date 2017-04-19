SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[sp_abcd]
as
select RSocial from Empresa where rsocial like '%art%'
GO
