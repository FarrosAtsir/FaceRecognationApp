import 'package:flutter/material.dart';

void customSnackBar(BuildContext context, String message, IconData icon){
  ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.blueAccent,
                                  shape: const StadiumBorder(),
                                  behavior: SnackBarBehavior.floating,
                                  content: Row(
                                    children: [
                                      Icon(
                                        icon,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        message,
                                        style: const TextStyle(
                                          color: Colors.white,
                                        )
                                      )
                                    ]
                                  )
                                )
                              );
}