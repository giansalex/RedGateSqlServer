CREATE TABLE [dbo].[AutCot]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Cot] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[NomUsu] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[FecAut] [datetime] NULL,
[Obs] [varchar] (300) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AutCot] WITH NOCHECK ADD CONSTRAINT [FK_AutCot_Cotizacion] FOREIGN KEY ([RucE], [Cd_Cot]) REFERENCES [dbo].[Cotizacion] ([RucE], [Cd_Cot])
GO
EXEC sp_addextendedproperty N'MS_Description', N'CT00000001', 'SCHEMA', N'dbo', 'TABLE', N'AutCot', 'COLUMN', N'Cd_Cot'
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'dbo', 'TABLE', N'AutCot', 'COLUMN', N'NomUsu'
GO
