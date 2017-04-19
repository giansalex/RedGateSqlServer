SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[NroReg_TipCamRM](@Cd_Est nvarchar(2))
returns int AS
begin 
      return (select isnull(Max(NroReg),0)+1 from TipCamRM where Cd_Est=@Cd_Est)

end

GO
