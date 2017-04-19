CREATE TABLE [dbo].[SerialMov]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Prod] [char] (7) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Serial] [varchar] (100) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Inv] [char] (12) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_Com] [char] (10) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_Vta] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SerialMov] WITH NOCHECK ADD CONSTRAINT [FK_SerialMov_Serial] FOREIGN KEY ([RucE], [Cd_Prod], [Serial]) REFERENCES [dbo].[Serial] ([RucE], [Cd_Prod], [Serial])
GO
EXEC sp_addextendedproperty N'MS_Description', N'CM00000001', 'SCHEMA', N'dbo', 'TABLE', N'SerialMov', 'COLUMN', N'Cd_Com'
GO
