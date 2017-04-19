SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [User123].[Igv]()
returns decimal(5,3) AS
begin 
       declare @c decimal(5,3)
       select @c = Tasa from Tasas where Cd_Ts='T01'
       return @c
end
GO
