#!/usr/bin/env python3
"""
Simple Figma MCP Server
Author: فريق وكلاء تطوير مشروع بصير
"""

import asyncio
import json
import os
import sys
from typing import Any, Dict, List, Optional

import httpx
from mcp.server import Server
from mcp.server.models import InitializationOptions
from mcp.server.stdio import stdio_server
from mcp.types import (
    CallToolRequest,
    CallToolResult,
    ListToolsRequest,
    ListToolsResult,
    Tool,
    TextContent,
)

# Figma API configuration
FIGMA_API_BASE = "https://api.figma.com/v1"
FIGMA_ACCESS_TOKEN = os.getenv("FIGMA_ACCESS_TOKEN")

class FigmaMCPServer:
    def __init__(self):
        self.server = Server("figma-mcp-server")
        self.client = httpx.AsyncClient(
            headers={
                "X-Figma-Token": FIGMA_ACCESS_TOKEN,
                "Content-Type": "application/json"
            } if FIGMA_ACCESS_TOKEN else {}
        )
        
        # Register handlers
        self.server.list_tools = self.list_tools
        self.server.call_tool = self.call_tool

    async def list_tools(self, request: ListToolsRequest) -> ListToolsResult:
        """List available Figma tools"""
        tools = [
            Tool(
                name="get_me",
                description="Get current user information from Figma",
                inputSchema={
                    "type": "object",
                    "properties": {},
                    "required": []
                }
            ),
            Tool(
                name="get_teams",
                description="Get teams for the current user",
                inputSchema={
                    "type": "object", 
                    "properties": {},
                    "required": []
                }
            ),
            Tool(
                name="get_team_projects",
                description="Get projects for a specific team",
                inputSchema={
                    "type": "object",
                    "properties": {
                        "team_id": {
                            "type": "string",
                            "description": "The team ID"
                        }
                    },
                    "required": ["team_id"]
                }
            ),
            Tool(
                name="get_project_files",
                description="Get files in a specific project",
                inputSchema={
                    "type": "object",
                    "properties": {
                        "project_id": {
                            "type": "string", 
                            "description": "The project ID"
                        }
                    },
                    "required": ["project_id"]
                }
            ),
            Tool(
                name="get_file",
                description="Get a specific Figma file",
                inputSchema={
                    "type": "object",
                    "properties": {
                        "file_key": {
                            "type": "string",
                            "description": "The file key"
                        }
                    },
                    "required": ["file_key"]
                }
            ),
            Tool(
                name="get_file_nodes",
                description="Get specific nodes from a Figma file",
                inputSchema={
                    "type": "object",
                    "properties": {
                        "file_key": {
                            "type": "string",
                            "description": "The file key"
                        },
                        "node_ids": {
                            "type": "array",
                            "items": {"type": "string"},
                            "description": "Array of node IDs"
                        }
                    },
                    "required": ["file_key", "node_ids"]
                }
            ),
            Tool(
                name="get_comments",
                description="Get comments for a Figma file",
                inputSchema={
                    "type": "object",
                    "properties": {
                        "file_key": {
                            "type": "string",
                            "description": "The file key"
                        }
                    },
                    "required": ["file_key"]
                }
            )
        ]
        
        return ListToolsResult(tools=tools)

    async def call_tool(self, request: CallToolRequest) -> CallToolResult:
        """Handle tool calls"""
        if not FIGMA_ACCESS_TOKEN:
            return CallToolResult(
                content=[
                    TextContent(
                        type="text",
                        text="Error: FIGMA_ACCESS_TOKEN environment variable not set"
                    )
                ]
            )

        try:
            if request.name == "get_me":
                return await self._get_me()
            elif request.name == "get_teams":
                return await self._get_teams()
            elif request.name == "get_team_projects":
                team_id = request.arguments.get("team_id")
                return await self._get_team_projects(team_id)
            elif request.name == "get_project_files":
                project_id = request.arguments.get("project_id")
                return await self._get_project_files(project_id)
            elif request.name == "get_file":
                file_key = request.arguments.get("file_key")
                return await self._get_file(file_key)
            elif request.name == "get_file_nodes":
                file_key = request.arguments.get("file_key")
                node_ids = request.arguments.get("node_ids", [])
                return await self._get_file_nodes(file_key, node_ids)
            elif request.name == "get_comments":
                file_key = request.arguments.get("file_key")
                return await self._get_comments(file_key)
            else:
                return CallToolResult(
                    content=[
                        TextContent(
                            type="text",
                            text=f"Unknown tool: {request.name}"
                        )
                    ]
                )
        except Exception as e:
            return CallToolResult(
                content=[
                    TextContent(
                        type="text",
                        text=f"Error calling {request.name}: {str(e)}"
                    )
                ]
            )

    async def _get_me(self) -> CallToolResult:
        """Get current user info"""
        response = await self.client.get(f"{FIGMA_API_BASE}/me")
        response.raise_for_status()
        data = response.json()
        
        return CallToolResult(
            content=[
                TextContent(
                    type="text",
                    text=json.dumps(data, indent=2)
                )
            ]
        )

    async def _get_teams(self) -> CallToolResult:
        """Get user teams"""
        response = await self.client.get(f"{FIGMA_API_BASE}/teams")
        response.raise_for_status()
        data = response.json()
        
        return CallToolResult(
            content=[
                TextContent(
                    type="text",
                    text=json.dumps(data, indent=2)
                )
            ]
        )

    async def _get_team_projects(self, team_id: str) -> CallToolResult:
        """Get projects for a team"""
        response = await self.client.get(f"{FIGMA_API_BASE}/teams/{team_id}/projects")
        response.raise_for_status()
        data = response.json()
        
        return CallToolResult(
            content=[
                TextContent(
                    type="text",
                    text=json.dumps(data, indent=2)
                )
            ]
        )

    async def _get_project_files(self, project_id: str) -> CallToolResult:
        """Get files in a project"""
        response = await self.client.get(f"{FIGMA_API_BASE}/projects/{project_id}/files")
        response.raise_for_status()
        data = response.json()
        
        return CallToolResult(
            content=[
                TextContent(
                    type="text",
                    text=json.dumps(data, indent=2)
                )
            ]
        )

    async def _get_file(self, file_key: str) -> CallToolResult:
        """Get a Figma file"""
        response = await self.client.get(f"{FIGMA_API_BASE}/files/{file_key}")
        response.raise_for_status()
        data = response.json()
        
        return CallToolResult(
            content=[
                TextContent(
                    type="text",
                    text=json.dumps(data, indent=2)
                )
            ]
        )

    async def _get_file_nodes(self, file_key: str, node_ids: List[str]) -> CallToolResult:
        """Get specific nodes from a file"""
        node_ids_str = ",".join(node_ids)
        response = await self.client.get(
            f"{FIGMA_API_BASE}/files/{file_key}/nodes",
            params={"ids": node_ids_str}
        )
        response.raise_for_status()
        data = response.json()
        
        return CallToolResult(
            content=[
                TextContent(
                    type="text",
                    text=json.dumps(data, indent=2)
                )
            ]
        )

    async def _get_comments(self, file_key: str) -> CallToolResult:
        """Get comments for a file"""
        response = await self.client.get(f"{FIGMA_API_BASE}/files/{file_key}/comments")
        response.raise_for_status()
        data = response.json()
        
        return CallToolResult(
            content=[
                TextContent(
                    type="text",
                    text=json.dumps(data, indent=2)
                )
            ]
        )

async def main():
    """Main entry point"""
    server_instance = FigmaMCPServer()
    
    async with stdio_server() as (read_stream, write_stream):
        await server_instance.server.run(
            read_stream,
            write_stream,
            InitializationOptions(
                server_name="figma-mcp-server",
                server_version="1.0.0",
                capabilities=server_instance.server.get_capabilities(
                    notification_options=None,
                    experimental_capabilities=None,
                )
            )
        )

if __name__ == "__main__":
    asyncio.run(main())